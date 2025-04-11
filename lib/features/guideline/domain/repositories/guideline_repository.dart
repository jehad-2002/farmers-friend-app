import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline_with_images.dart';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:dartz/dartz.dart';

abstract class GuidelineRepository {
  Future<Either<Failure, List<Guideline>>> getGuidelinesForCrop(int cropId);
  Future<Either<Failure, List<Guideline>>> getAllGuidelines();
  Future<Either<Failure, Guideline>> addGuideline(Guideline guideline);
  Future<Either<Failure, Guideline>> updateGuideline(Guideline guideline);
  Future<Either<Failure, void>> deleteGuideline(int guidelineId);
  Future<Either<Failure, List<GuidelineImage>>> getImagesForGuideline(
      int guidanceId);
  Future<Either<Failure, GuidelineImage>> addImageToGuideline(
      GuidelineImage guidelineImage);
  Future<Either<Failure, void>> deleteGuidelineImage(int imageGuidelineId);
  Future<Either<Failure, List<GuidelineWithImages>>>
      getGuidelinesWithImagesByCrop(int cropId);
  Future<Either<Failure, List<GuidelineWithImages>>>
      getAllGuidelinesWithImages();
}
