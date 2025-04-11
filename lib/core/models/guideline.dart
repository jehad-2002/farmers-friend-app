import 'package:equatable/equatable.dart';

class Guideline extends Equatable {
  final int? guidanceId;
  final int userId;
  final int cropId;
  final String title;
  final String guidanceText;
  final String? publicationDate;

  const Guideline({
    this.guidanceId,
    required this.userId,
    required this.cropId,
    required this.title,
    required this.guidanceText,
    this.publicationDate,
  });

  @override
  List<Object?> get props =>
      [guidanceId, userId, cropId, title, guidanceText, publicationDate];

  Map<String, dynamic> toMap() {
    return {
      'GuidanceID': guidanceId,
      'UserID': userId,
      'CropID': cropId,
      'Title': title,
      'GuidanceText': guidanceText,
      'PublicationDate': publicationDate,
    };
  }

  factory Guideline.fromMap(Map<String, dynamic> map) {
    return Guideline(
      guidanceId: map['GuidanceID'] as int?,
      userId: map['UserID'] as int,
      cropId: map['CropID'] as int,
      title: map['Title'] as String,
      guidanceText: map['GuidanceText'] as String,
      publicationDate: map['PublicationDate'] as String?,
    );
  }

  Guideline copyWith({
    int? guidanceId,
    int? userId,
    int? cropId,
    String? title,
    String? guidanceText,
    String? publicationDate,
  }) {
    return Guideline(
      guidanceId: guidanceId ?? this.guidanceId,
      userId: userId ?? this.userId,
      cropId: cropId ?? this.cropId,
      title: title ?? this.title,
      guidanceText: guidanceText ?? this.guidanceText,
      publicationDate: publicationDate ?? this.publicationDate,
    );
  }
}

