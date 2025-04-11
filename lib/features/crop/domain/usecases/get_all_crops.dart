import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:farmersfriendapp/features/crop/domain/repositories/crop_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCrops {
  final CropRepository repository;

  GetAllCrops(this.repository);

  Future<Either<Failure, List<Crop>>> call() async {
    return await repository.getAllCrops();
  }
}
