import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:farmersfriendapp/features/crop/data/datasources/crop_local_datasource.dart';
import 'package:farmersfriendapp/features/crop/domain/repositories/crop_repository.dart';
import 'package:dartz/dartz.dart';

class CropRepositoryImpl implements CropRepository {
  final CropLocalDataSource localDataSource;
  CropRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Crop>>> getAllCrops() async {
    try {
      final crops = await localDataSource.getAllCrops();
      return Right(crops);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Crop>> addCrop(Crop crop) async {
    try {
      final newCrop = await localDataSource.addCrop(crop);
      return Right(newCrop);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Crop>> updateCrop(Crop crop) async {
    try {
      final updatedCrop = await localDataSource.updateCrop(crop);
      return Right(updatedCrop);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCrop(int cropId) async {
    try {
      await localDataSource.deleteCrop(cropId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Crop?>> getCropById(int cropId) async {
    try {
      final crop = await localDataSource.getCropById(cropId);
      return Right(crop);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
