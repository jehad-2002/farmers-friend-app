import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:dartz/dartz.dart';

abstract class CropRepository {
  Future<Either<Failure, List<Crop>>> getAllCrops();
  Future<Either<Failure, Crop>> addCrop(Crop crop);
  Future<Either<Failure, Crop>> updateCrop(Crop crop);
  Future<Either<Failure, void>> deleteCrop(int cropId);
  Future<Either<Failure, Crop?>> getCropById(int cropId);
}
