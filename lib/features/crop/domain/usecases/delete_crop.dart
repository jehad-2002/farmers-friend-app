import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/crop/domain/repositories/crop_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteCrop {
  final CropRepository repository;

  DeleteCrop(this.repository);

  Future<Either<Failure, void>> call(int cropId) async {
    return await repository.deleteCrop(cropId);
  }
}
