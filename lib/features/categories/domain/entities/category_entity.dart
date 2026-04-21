import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String key;
  final String name;
  final String? image;

  const CategoryEntity({
    required this.id,
    required this.key,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, key, name, image];
}
