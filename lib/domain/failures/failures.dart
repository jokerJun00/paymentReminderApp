abstract class Failure {
  Failure({required this.error});

  final String error;

  String get getError {
    return error;
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.error});
}

class CacheFailure extends Failure {
  CacheFailure({required super.error});
}

class FirebaseAuthFailure extends Failure {
  FirebaseAuthFailure({required super.error});
}

class GeneralFailure extends Failure {
  GeneralFailure({required super.error});
}
