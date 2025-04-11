import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class AddGuidelineImage {
  final GuidelineRepository repository;
  AddGuidelineImage(this.repository);
  Future<Either<Failure, GuidelineImage>> call(
      GuidelineImage guidelineImage) async {
    return await repository.addImageToGuideline(guidelineImage);
  }
}
