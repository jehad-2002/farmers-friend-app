import 'package:farmersfriendapp/core/database/database_helper.dart';
import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/models/evaluation.dart';

abstract class EvaluationLocalDataSource {
  Future<List<Evaluations>> getEvaluationsForProduct(int productId);
  Future<Evaluations> addEvaluation(Evaluations evaluation);
  Future<Evaluations> updateEvaluation(Evaluations evaluation);
  Future<void> deleteEvaluation(int evaluationId);
}

class EvaluationLocalDataSourceImpl implements EvaluationLocalDataSource {
  final DatabaseHelper dbHelper;

  EvaluationLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<Evaluations>> getEvaluationsForProduct(int productId) async {
    try {
      final maps = await dbHelper.query(
        'Evaluations',
        where: 'ProductID = ?',
        whereArgs: [productId],
      );
      return maps.map((map) => Evaluations.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get evaluations: $e');
    }
  }

  @override
  Future<Evaluations> addEvaluation(Evaluations evaluation) async {
    try {
      final evaluationId =
          await dbHelper.insert('Evaluations', evaluation.toMap());
      return evaluation.copyWith(evaluationId: evaluationId);
    } catch (e) {
      throw DatabaseException('Failed to add evaluation: $e');
    }
  }

  @override
  Future<Evaluations> updateEvaluation(Evaluations evaluation) async {
    try {
      await dbHelper.update(
        'Evaluations',
        evaluation.toMap(),
        where: 'EvaluationID = ?',
        whereArgs: [evaluation.evaluationId],
      );
      return evaluation;
    } catch (e) {
      throw DatabaseException('Failed to update evaluation: $e');
    }
  }

  @override
  Future<void> deleteEvaluation(int evaluationId) async {
    try {
      await dbHelper.delete(
        'Evaluations',
        where: 'EvaluationID = ?',
        whereArgs: [evaluationId],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete evaluation: $e');
    }
  }
}
