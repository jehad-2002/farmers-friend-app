import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/evaluation.dart';
import 'package:farmersfriendapp/features/evaluation/domain/repositories/evaluation_repository.dart';
import 'package:dartz/dartz.dart';

class AddEvaluation {
  final EvaluationRepository repository;
  AddEvaluation(this.repository);

  Future<Either<Failure, Evaluations>> call(Evaluations evaluation) async {
    return await repository.addEvaluation(evaluation);
  }
}
