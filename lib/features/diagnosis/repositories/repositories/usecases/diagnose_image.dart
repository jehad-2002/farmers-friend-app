import 'dart:io';
import 'package:dartz/dartz.dart'; // Or fpdartz
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/diagnosis/domain/repositories/diagnosis_repository.dart';

class DiagnoseImage {
  final DiagnosisRepository repository;

  DiagnoseImage(this.repository);

  Future<Either<Failure, String>> call(File imageFile) async {
    return await repository.diagnoseImage(imageFile);
  }
}
