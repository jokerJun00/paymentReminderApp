import 'package:equatable/equatable.dart';

abstract class Failure {
  Failure({required this.error});

  final String error;

  String get getError {
    return error;
  }
}

class ServerFailure extends Failure with EquatableMixin {
  ServerFailure({required super.error});

  @override
  List<Object?> get props => [error];
}

class FirebaseAuthFailure extends Failure with EquatableMixin {
  FirebaseAuthFailure({required super.error});

  @override
  List<Object?> get props => [error];
}

class GeneralFailure extends Failure with EquatableMixin {
  GeneralFailure({required super.error});

  @override
  List<Object?> get props => [error];
}
