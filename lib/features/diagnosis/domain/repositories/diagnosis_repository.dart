import 'dart:io';
import 'package:dartz/dartz.dart'; // Or fpdartz
import 'package:farmersfriendapp/core/errors/failures.dart';

abstract class DiagnosisRepository {
  // Takes an image file and returns either a Failure or the diagnosis result string
  Future<Either<Failure, String>> diagnoseImage(File imageFile);
}
