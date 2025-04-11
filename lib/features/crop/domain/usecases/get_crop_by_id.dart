import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:farmersfriendapp/features/crop/domain/repositories/crop_repository.dart';
import 'package:dartz/dartz.dart';

class GetCropById {
  final CropRepository repository;

  GetCropById(this.repository);

  Future<Either<Failure, Crop?>> call(int cropId) async {
    return await repository.getCropById(cropId);
  }
}
