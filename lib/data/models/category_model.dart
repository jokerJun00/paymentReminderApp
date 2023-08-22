import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity with EquatableMixin {
  CategoryModel(
      {required super.id, required super.name, required super.user_id});

  factory CategoryModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> categoryData) {
    final data = categoryData.data()!;

    return CategoryModel(
      id: categoryData.id,
      name: data["name"],
      user_id: data["user_id"],
    );
  }
}
