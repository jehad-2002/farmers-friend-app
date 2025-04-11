import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:farmersfriendapp/features/crop/domain/repositories/crop_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateCrop {
  final CropRepository repository;
  UpdateCrop(this.repository);
  Future<Either<Failure, Crop>> call(Crop crop) async {
    return await repository.updateCrop(crop);
  }
}
