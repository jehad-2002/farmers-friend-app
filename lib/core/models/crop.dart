import 'package:equatable/equatable.dart';

class Crop extends Equatable {
  final int? cropId;
  final String cropName;
  final String? cropDescription;
  final String? cropImage;
  final int categoryId;

  const Crop({
    this.cropId,
    required this.cropName,
    this.cropDescription,
    this.cropImage,
    required this.categoryId,
  });

  @override
  List<Object?> get props =>
      [cropId, cropName, cropDescription, cropImage, categoryId];

  Map<String, dynamic> toMap() {
    return {
      'CropID': cropId,
      'CropName': cropName,
      'CropDescription': cropDescription,
      'CropImage': cropImage,
      'CategoryID': categoryId,
    };
  }

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      cropId: map['CropID'],
      cropName: map['CropName'],
      cropDescription: map['CropDescription'],
      cropImage: map['CropImage'],
      categoryId: map['CategoryID'],
    );
  }

  Crop copyWith({
    int? cropId,
    String? cropName,
    String? cropDescription,
    String? cropImage,
    int? categoryId,
  }) {
    return Crop(
      cropId: cropId ?? this.cropId,
      cropName: cropName ?? this.cropName,
      cropDescription: cropDescription ?? this.cropDescription,
      cropImage: cropImage ?? this.cropImage,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
