import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ReceiverEntity extends Equatable {
  ReceiverEntity({
    required this.id,
    required this.name,
    required this.bank_id,
    required this.bank_account_no,
    required this.user_id,
  });

  String id;
  String name;
  String bank_id;
  String bank_account_no;
  String user_id;

  @override
  List<Object?> get props => [name, bank_id, bank_account_no, user_id];
}
