import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/evaluation/domain/repositories/evaluation_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteEvaluation {
  final EvaluationRepository repository;

  DeleteEvaluation(this.repository);

  Future<Either<Failure, void>> call(int evaluationId) async {
    return await repository.deleteEvaluation(evaluationId);
  }
}
