import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class GetGuidelinesForCrop {
  final GuidelineRepository repository;

  GetGuidelinesForCrop(this.repository);

  Future<Either<Failure, List<Guideline>>> call(int cropId) async {
    return await repository.getGuidelinesForCrop(cropId);
  }
}
