import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/evaluation.dart';
import 'package:farmersfriendapp/features/evaluation/domain/repositories/evaluation_repository.dart';
import 'package:dartz/dartz.dart';

class GetEvaluationsForProduct {
  final EvaluationRepository repository;

  GetEvaluationsForProduct(this.repository);

  Future<Either<Failure, List<Evaluations>>> call(int productId) async {
    return await repository.getEvaluationsForProduct(productId);
  }
}
