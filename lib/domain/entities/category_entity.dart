import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.user_id,
  });

  final String id;
  final String name;
  final String user_id;

  @override
  List<Object?> get props => [name, user_id];
}
