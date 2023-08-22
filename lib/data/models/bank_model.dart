import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/bank_entity.dart';

class BankModel extends BankEntity with EquatableMixin {
  BankModel({required super.id, required super.name});

  factory BankModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> bankData) {
    final data = bankData.data()!;

    return BankModel(
      id: bankData.id,
      name: data["name"],
    );
  }
}
