import 'dart:io';
import 'package:dartz/dartz.dart'; // Or fpdartz if you prefer
import 'package:farmersfriendapp/core/errors/failures.dart'; // تأكد من صحة هذا المسار

// العقد (Interface) لـ Diagnosis Repository
// يحدد العمليات المتاحة المتعلقة بالتشخيص
abstract class DiagnosisRepository {
  /// يأخذ ملف صورة ويرجع إما خطأ (Failure) أو نتيجة التشخيص (String).
  Future<Either<Failure, String>> diagnoseImage(File imageFile);
}