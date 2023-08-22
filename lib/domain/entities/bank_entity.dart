import 'package:equatable/equatable.dart';

class BankEntity extends Equatable {
  const BankEntity({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object?> get props => [name];
}
