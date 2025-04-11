import 'package:equatable/equatable.dart';

class guidelineImage extends Equatable {
  final int? imageId;
  final String imagePath;
  final int productId;

  const guidelineImage(
      {this.imageId, required this.imagePath, required this.productId});

  @override
  List<Object?> get props => [imageId, imagePath, productId];

  Map<String, dynamic> toMap() {
    return {'ImageID': imageId, 'ImagePath': imagePath, 'ProductID': productId};
  }

  factory guidelineImage.fromMap(Map<String, dynamic> map) {
    return guidelineImage(
        imageId: map['ImageID'] as int?,
        imagePath: map['ImagePath'] as String,
        productId: map['ProductID'] as int);
  }

  guidelineImage copyWith({
    int? imageId,
    String? imagePath,
    int? productId,
  }) {
    return guidelineImage(
      imageId: imageId ?? this.imageId,
      imagePath: imagePath ?? this.imagePath,
      productId: productId ?? this.productId,
    );
  }
}


