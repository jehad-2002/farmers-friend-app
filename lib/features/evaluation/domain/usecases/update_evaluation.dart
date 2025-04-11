import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/evaluation.dart';
import 'package:farmersfriendapp/features/evaluation/domain/repositories/evaluation_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateEvaluation {
  final EvaluationRepository repository;
  UpdateEvaluation(this.repository);
  Future<Either<Failure, Evaluations>> call(Evaluations evaluation) async {
    return await repository.updateEvaluation(evaluation);
  }
}
