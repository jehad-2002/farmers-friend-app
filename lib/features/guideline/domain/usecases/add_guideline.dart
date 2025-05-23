import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:dartz/dartz.dart';

class AddGuideline {
  final GuidelineRepository repository;
  AddGuideline(this.repository);

  Future<Either<Failure, Guideline>> call(Guideline guideline) async {
    return await repository.addGuideline(guideline);
  }
}
