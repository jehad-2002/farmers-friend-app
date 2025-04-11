import 'package:equatable/equatable.dart';

class GuidelineImage extends Equatable {
  final int? imageGuidelineId;
  final String imagePath;
  final int guidanceId;

  const GuidelineImage(
      {this.imageGuidelineId,
      required this.imagePath,
      required this.guidanceId});

  @override
  List<Object?> get props => [imageGuidelineId, imagePath, guidanceId];

  Map<String, dynamic> toMap() {
    return {
      'ImageGuidelineID': imageGuidelineId,
      'ImagePath': imagePath,
      'GuidanceID': guidanceId
    };
  }

  factory GuidelineImage.fromMap(Map<String, dynamic> map) {
    return GuidelineImage(
        imageGuidelineId: map['ImageGuidelineID'] as int?,
        imagePath: map['ImagePath'] as String,
        guidanceId: map['GuidanceID'] as int);
  }
  GuidelineImage copyWith({
    int? imageGuidelineId,
    String? imagePath,
    int? guidanceId,
  }) {
    return GuidelineImage(
      imageGuidelineId: imageGuidelineId ?? this.imageGuidelineId,
      imagePath: imagePath ?? this.imagePath,
      guidanceId: guidanceId ?? this.guidanceId,
    );
  }
}
