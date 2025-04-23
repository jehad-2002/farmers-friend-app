import 'dart:io'; // Required for File type
import 'package:dartz/dartz.dart'; // For Either type (functional error handling)
import 'package:farmersfriendapp/core/errors/failures.dart'; // Your custom Failure types
import 'package:farmersfriendapp/features/diagnosis/data/diagnosis/diagnosis_local_datasource.dart';
import 'package:farmersfriendapp/features/diagnosis/domain/repositories/diagnosis_repository.dart'; // The abstract repository interface this implements

/// Implementation of the [DiagnosisRepository].
///
/// This class acts as a bridge between the domain layer (use cases) and the
/// data layer (local data source). It handles potential errors from the
/// data source and converts them into specific [Failure] types that the
/// domain layer can understand and handle gracefully.
class DiagnosisRepositoryImpl implements DiagnosisRepository {
  /// The local data source responsible for loading and running the TFLite model.
  final DiagnosisLocalDataSource localDataSource;

  /// Creates an instance of [DiagnosisRepositoryImpl].
  ///
  /// Requires a [DiagnosisLocalDataSource] to interact with the model.
  DiagnosisRepositoryImpl({required this.localDataSource});

  /// Diagnoses the plant disease from the provided [imageFile].
  ///
  /// Calls the `runDiagnosis` method on the [localDataSource].
  /// Catches potential exceptions from the data source and maps them
  /// to appropriate [Failure] subtypes (e.g., [ModelInferenceFailure],
  /// [ImageProcessingFailure]).
  ///
  /// Returns:
  /// - [Right<String>] containing the formatted diagnosis result string on success.
  /// - [Left<Failure>] containing a specific [Failure] object on error.
  @override
  Future<Either<Failure, String>> diagnoseImage(File imageFile) async {
    try {
      // Attempt to run the diagnosis using the local data source
      final String diagnosisResult =
          await localDataSource.runDiagnosis(imageFile);
      // If successful, return the result wrapped in a Right
      return Right(diagnosisResult);
    } on Exception catch (e) {
      // Handle exceptions caught from the local data source
      print("Diagnosis Repository Error: $e"); // Log the specific exception

      // Map common exceptions to specific Failure types for better handling in UI/Bloc
      final errorMessage = e.toString();

      if (errorMessage.contains('Failed to decode image') ||
          errorMessage.contains('invalid image')) {
        // Error related to reading or understanding the image file
        return Left(ImageProcessingFailure(errorMessage));
      } else if (errorMessage.contains('model') ||
          errorMessage.contains('interpreter') ||
          errorMessage.contains('tensor')) {
        // Error related to loading or running the TFLite model
        return Left(ModelInferenceFailure(errorMessage));
      } else if (errorMessage.contains('index') &&
          errorMessage.contains('out of bounds')) {
        // Error related to mismatch between model output and class mapping
        return Left(
            ModelInferenceFailure('Model output mismatch: $errorMessage'));
      }
      // Generic fallback for other exceptions from the data source
      return Left(ModelInferenceFailure('Diagnosis failed: $errorMessage'));
    } catch (e) {
      // Catch any other unexpected errors during the process
      print("Unexpected Diagnosis Repository Error: $e");
      return Left(ModelInferenceFailure(
          'An unexpected error occurred during diagnosis: ${e.toString()}'));
    }
  }
}
