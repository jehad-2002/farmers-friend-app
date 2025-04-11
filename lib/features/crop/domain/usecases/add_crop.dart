import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:dartz/dartz.dart';
import 'package:farmersfriendapp/features/crop/domain/repositories/crop_repository.dart';

class AddCrop {
  final CropRepository repository;
  AddCrop(this.repository);

  Future<Either<Failure, Crop>> call(Crop crop) async {
    return await repository.addCrop(crop);
  }
}
