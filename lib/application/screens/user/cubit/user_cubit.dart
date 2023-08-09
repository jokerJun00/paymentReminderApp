import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:payment_reminder_app/domain/usecases/user_usecases.dart';

import '../../../../domain/entities/user_entitiy.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit()
      : super(UserStateInitial(
            user: UserModel(id: "", name: "", email: "", contactNo: "")));

  final UserUseCases userUseCases = UserUseCases();

  void getUser() async {
    emit(UserStateLoadingData());

    final userOrFailure = await userUseCases.getUser();
    return userOrFailure.fold(
      (user) => emit(UserStateInitial(user: user)),
      (failure) => emit(UserStateError(message: failure.getError)),
    );
  }

  void editUserProfile(String id, String username, String email,
      String contactNo, String oldEmail, String password) async {
    emit(UserStateEditingData());

    final userOrFailure = await userUseCases.editUser(
      id,
      username,
      email,
      contactNo,
      oldEmail,
      password,
    );
    userOrFailure.fold(
      (user) {
        emit(UserStateEditSuccess());
        emit(UserStateInitial(user: user));
      },
      (failure) => emit(UserStateError(message: failure.getError)),
    );
  }

  void editPassword(UserModel user, String email, String oldPassword,
      String newPassword) async {
    emit(UserStateEditingData());

    final voidOrFailure =
        await userUseCases.editPassword(email, oldPassword, newPassword);

    voidOrFailure.fold((value) {
      emit(UserStateEditSuccess());
      emit(UserStateInitial(user: user));
    }, (failure) => emit(UserStateError(message: failure.getError)));
  }
}
