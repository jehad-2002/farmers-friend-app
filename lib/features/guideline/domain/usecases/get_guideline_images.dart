import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class GetGuidelineImages {
  final GuidelineRepository repository;

  GetGuidelineImages(this.repository);

  Future<Either<Failure, List<GuidelineImage>>> call(int guidanceId) async {
    return await repository.getImagesForGuideline(guidanceId);
  }
}
