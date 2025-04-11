import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteGuideline {
  final GuidelineRepository repository;

  DeleteGuideline(this.repository);

  Future<Either<Failure, void>> call(int guidelineId) async {
    return await repository.deleteGuideline(guidelineId);
  }
}
