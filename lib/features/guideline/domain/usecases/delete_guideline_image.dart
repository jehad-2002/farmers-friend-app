import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteGuidelineImage {
  final GuidelineRepository repository;

  DeleteGuidelineImage(this.repository);

  Future<Either<Failure, void>> call(int imageGuidelineId) async {
    return await repository.deleteGuidelineImage(imageGuidelineId);
  }
}
