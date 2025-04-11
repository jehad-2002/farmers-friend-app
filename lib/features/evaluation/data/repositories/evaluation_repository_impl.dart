import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/evaluation.dart';
import 'package:farmersfriendapp/features/evaluation/data/datasources/evaluation_local_datasource.dart';
import 'package:farmersfriendapp/features/evaluation/domain/repositories/evaluation_repository.dart';
import 'package:dartz/dartz.dart';

class EvaluationRepositoryImpl implements EvaluationRepository {
  final EvaluationLocalDataSource localDataSource;

  EvaluationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Evaluations>>> getEvaluationsForProduct(
      int productId) async {
    try {
      final evaluations =
          await localDataSource.getEvaluationsForProduct(productId);
      return Right(evaluations);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Evaluations>> addEvaluation(
      Evaluations evaluation) async {
    try {
      final newEvaluation = await localDataSource.addEvaluation(evaluation);
      return Right(newEvaluation);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Evaluations>> updateEvaluation(
      Evaluations evaluation) async {
    try {
      final updatedEvaluation =
          await localDataSource.updateEvaluation(evaluation);
      return Right(updatedEvaluation);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvaluation(int evaluationId) async {
    try {
      await localDataSource.deleteEvaluation(evaluationId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
