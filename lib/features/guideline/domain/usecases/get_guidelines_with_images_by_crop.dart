import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline_with_images.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class GetGuidelinesWithImagesByCrop {
  final GuidelineRepository repository;

  GetGuidelinesWithImagesByCrop(this.repository);

  Future<Either<Failure, List<GuidelineWithImages>>> call(int cropId) async {
    return await repository.getGuidelinesWithImagesByCrop(cropId);
  }
}
