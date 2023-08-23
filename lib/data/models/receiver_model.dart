import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/receiver_entity.dart';

class ReceiverModel extends ReceiverEntity with EquatableMixin {
  ReceiverModel({
    required super.id,
    required super.name,
    required super.bank_id,
    required super.bank_account_no,
    required super.user_id,
  });

  factory ReceiverModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> receiverData) {
    final data = receiverData.data()!;

    return ReceiverModel(
      id: receiverData.id,
      name: data["name"],
      bank_id: data["bank_id"],
      bank_account_no: data["bank_account_no"],
      user_id: data["user_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bank_id': bank_id,
      'bank_account_no': bank_account_no,
      'user_id': user_id,
    };
  }
}
