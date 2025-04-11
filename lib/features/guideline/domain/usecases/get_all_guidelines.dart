import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllGuidelines {
  final GuidelineRepository repository;

  GetAllGuidelines(this.repository);

  Future<Either<Failure, List<Guideline>>> call() async {
    return await repository.getAllGuidelines();
  }
}
