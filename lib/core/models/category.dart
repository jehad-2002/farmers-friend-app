import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? categoryId;
  final String categoryName;
  final String? categoryDescription;

  const Category({
    this.categoryId,
    required this.categoryName,
    this.categoryDescription,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, categoryDescription];

  Map<String, dynamic> toMap() {
    return {
      'CategoryID': categoryId,
      'CategoryName': categoryName,
      'CategoryDescription': categoryDescription,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['CategoryID'],
      categoryName: map['CategoryName'],
      categoryDescription: map['CategoryDescription'],
    );
  }

  Category copyWith({
    int? categoryId,
    String? categoryName,
    String? categoryDescription,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryDescription: categoryDescription ?? this.categoryDescription,
    );
  }
}
