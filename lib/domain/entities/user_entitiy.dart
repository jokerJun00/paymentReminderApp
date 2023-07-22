import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
  });

  final String id;
  final String name;
  final String email;
  final String contactNo;

  @override
  List<Object?> get props => [name, email, contactNo];
}
