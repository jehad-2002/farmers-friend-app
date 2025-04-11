import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/diagnosis/data/diagnosis/diagnosis_local_datasource.dart';
import 'package:farmersfriendapp/features/diagnosis/domain/repositories/diagnosis_repository.dart';

class DiagnosisRepositoryImpl implements DiagnosisRepository {
  final DiagnosisLocalDataSource localDataSource;

  DiagnosisRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, String>> diagnoseImage(File imageFile) async {
    try {
      final String diagnosisResult = await localDataSource.runDiagnosis(imageFile);
      return Right(diagnosisResult);
    } on Exception catch (e) {
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('decode image') || errorMessage.contains('invalid image')) {
        return Left(ImageProcessingFailure("فشل في معالجة الصورة: ${e.toString()}"));
      } else if (errorMessage.contains('model') ||
          errorMessage.contains('interpreter') ||
          errorMessage.contains('tensor') ||
          errorMessage.contains('load')) {
        return Left(ModelInferenceFailure("فشل في النموذج أو الاستدلال: ${e.toString()}"));
      } else if (errorMessage.contains('index') && errorMessage.contains('out of bounds')) {
        return Left(ModelInferenceFailure('عدم تطابق في مخرجات النموذج: ${e.toString()}'));
      }
      return Left(ModelInferenceFailure('فشل التشخيص لسبب غير محدد: ${e.toString()}'));
    } catch (e) {
      return Left(ModelInferenceFailure('حدث خطأ غير متوقع أثناء التشخيص: ${e.toString()}'));
    }
  }
}
