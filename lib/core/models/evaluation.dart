import 'package:equatable/equatable.dart';

class Evaluations extends Equatable {
  final int? evaluationId;
  final int rating;
  final String? comment;
  final int productId;
  final int userId;

  const Evaluations({
    this.evaluationId,
    required this.rating,
    this.comment,
    required this.productId,
    required this.userId,
  });

  @override
  List<Object?> get props => [evaluationId, rating, comment, productId, userId];

  Map<String, dynamic> toMap() {
    return {
      'EvaluationID': evaluationId,
      'Rating': rating,
      'Comment': comment,
      'ProductID': productId,
      'UserID': userId,
    };
  }

  factory Evaluations.fromMap(Map<String, dynamic> map) {
    return Evaluations(
      evaluationId: map['EvaluationID'] as int?,
      rating: map['Rating'] as int,
      comment: map['Comment'] as String?,
      productId: map['ProductID'] as int,
      userId: map['UserID'] as int,
    );
  }

  Evaluations copyWith({
    int? evaluationId,
    int? rating,
    String? comment,
    int? productId,
    int? userId,
  }) {
    return Evaluations(
      evaluationId: evaluationId ?? this.evaluationId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
    );
  }
}
