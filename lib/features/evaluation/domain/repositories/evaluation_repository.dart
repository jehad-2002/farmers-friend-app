import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/evaluation.dart';
import 'package:dartz/dartz.dart';

abstract class EvaluationRepository {
  Future<Either<Failure, List<Evaluations>>> getEvaluationsForProduct(
      int productId);
  Future<Either<Failure, Evaluations>> addEvaluation(Evaluations evaluation);
  Future<Either<Failure, Evaluations>> updateEvaluation(Evaluations evaluation);
  Future<Either<Failure, void>> deleteEvaluation(int evaluationId);
}
