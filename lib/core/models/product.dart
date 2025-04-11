import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int? productId;
  final int userId;
  final String title;
  final String? description;
  final double price;
  final String dateAdded;
  final int cropId;

  const Product({
    this.productId,
    required this.userId,
    required this.title,
    this.description,
    required this.price,
    required this.dateAdded,
    required this.cropId,
  });

  @override
  List<Object?> get props =>
      [productId, userId, title, description, price, dateAdded, cropId];

  Map<String, dynamic> toMap() {
    return {
      'ProductID': productId,
      'UserID': userId,
      'Title': title,
      'Description': description,
      'Price': price,
      'DateAdded': dateAdded,
      'CropID': cropId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['ProductID'] as int?,
      userId: map['UserID'] as int,
      title: map['Title'] as String,
      description: map['Description'] as String?,
      price: (map['Price'] as num).toDouble(),
      dateAdded: map['DateAdded'] as String,
      cropId: map['CropID'] as int,
    );
  }

  Product copyWith({
    int? productId,
    int? userId,
    String? title,
    String? description,
    double? price,
    String? dateAdded,
    int? cropId,
  }) {
    return Product(
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      dateAdded: dateAdded ?? this.dateAdded,
      cropId: cropId ?? this.cropId,
    );
  }
}

