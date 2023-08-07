import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/usecases/user_usecases.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit()
      : super(UserStateInitial(
            user: UserModel(id: "", name: "", email: "", contactNo: "")));

  final UserUseCases userUseCases = UserUseCases();

  void getUser() async {
    emit(UserStateLoadingData());

    final userOrFailure = await userUseCases.getUser();
    print("user or failure =============> $userOrFailure");
    userOrFailure.fold(
      (user) => emit(UserStateInitial(user: user)),
      (failure) => emit(UserStateError(message: failure.getError)),
    );

    print("Current State ==============> $state");
  }

  void editUserProfile() {
    emit(UserStateEditingData());

    emit(UserStateEditSuccess());

    UserModel user = UserModel(
      id: "1",
      name: "Yap Siew Fan",
      email: "junkiat54@gmail.com",
      contactNo: "+60176835363",
    );

    emit(UserStateInitial(user: user));
  }

  void editPassword(UserModel user) {
    emit(UserStateEditingData());

    emit(UserStateEditSuccess());

    emit(UserStateInitial(user: user));
  }
}
