import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  final int? imageId;
  final String imagePath;
  final int productId;

  const ProductImage(
      {this.imageId, required this.imagePath, required this.productId});

  @override
  List<Object?> get props => [imageId, imagePath, productId];

  Map<String, dynamic> toMap() {
    return {'ImageID': imageId, 'ImagePath': imagePath, 'ProductID': productId};
  }

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
        imageId: map['ImageID'] as int?,
        imagePath: map['ImagePath'] as String,
        productId: map['ProductID'] as int);
  }

  ProductImage copyWith({
    int? imageId,
    String? imagePath,
    int? productId,
  }) {
    return ProductImage(
      imageId: imageId ?? this.imageId,
      imagePath: imagePath ?? this.imagePath,
      productId: productId ?? this.productId,
    );
  }
}


