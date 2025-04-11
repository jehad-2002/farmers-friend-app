import 'dart:io';
import 'package:dartz/dartz.dart'; // Or fpdartz
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/diagnosis/domain/repositories/diagnosis_repository.dart';

// Use case for diagnosing an image
class DiagnoseImage {
  final DiagnosisRepository repository;

  DiagnoseImage(this.repository);

  // Makes the class callable like a function
  Future<Either<Failure, String>> call(File imageFile) async {
    // Basic validation could be added here if needed (e.g., file size)
    return await repository.diagnoseImage(imageFile);
  }
}
