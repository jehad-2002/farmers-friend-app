import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline_with_images.dart';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/features/guideline/data/datasources/guideline_local_datasource.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class GuidelineRepositoryImpl implements GuidelineRepository {
  final GuidelineLocalDataSource localDataSource;

  GuidelineRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Guideline>>> getGuidelinesForCrop(
      int cropId) async {
    try {
      final guidelines = await localDataSource.getGuidelinesForCrop(cropId);
      return Right(guidelines);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Guideline>> addGuideline(Guideline guideline) async {
    try {
      final newGuideline = await localDataSource.addGuideline(guideline);
      return Right(newGuideline);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Guideline>> updateGuideline(
      Guideline guideline) async {
    try {
      final updatedGuideline = await localDataSource.updateGuideline(guideline);
      return Right(updatedGuideline);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGuideline(int guidelineId) async {
    try {
      await localDataSource.deleteGuideline(guidelineId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<GuidelineImage>>> getImagesForGuideline(
      int guidanceId) async {
    try {
      final guidelineImages =
          await localDataSource.getImagesForGuideline(guidanceId);
      return Right(guidelineImages);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, GuidelineImage>> addImageToGuideline(
      GuidelineImage guidelineImage) async {
    try {
      final newGuidelineImage =
          await localDataSource.addImageToGuideline(guidelineImage);
      return Right(newGuidelineImage);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGuidelineImage(
      int imageGuidelineId) async {
    try {
      await localDataSource.deleteGuidelineImage(imageGuidelineId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Guideline>>> getAllGuidelines() async {
    try {
      final guidelines = await localDataSource.getAllGuidelines();
      return Right(guidelines);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<GuidelineWithImages>>>
      getGuidelinesWithImagesByCrop(int cropId) async {
    try {
      final guidelinesWithImages =
          await localDataSource.getGuidelinesWithImagesByUserId(cropId);
      return Right(guidelinesWithImages);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<GuidelineWithImages>>>
      getAllGuidelinesWithImages() async {
    try {
      final guidelinesWithImages =
          await localDataSource.getAllGuidelinesWithImages();
      return Right(guidelinesWithImages);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
