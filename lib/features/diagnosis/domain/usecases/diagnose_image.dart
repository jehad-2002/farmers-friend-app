import 'dart:io';
import 'package:dartz/dartz.dart'; // Or fpdartz
import 'package:farmersfriendapp/core/errors/failures.dart'; // تأكد من صحة هذا المسار
import 'package:farmersfriendapp/features/diagnosis/domain/repositories/diagnosis_repository.dart'; // تأكد من صحة هذا المسار

/// حالة الاستخدام لتشخيص صورة.
/// تفصل منطق العمل عن تفاصيل التنفيذ في الواجهة أو مصادر البيانات.
class DiagnoseImage {
  final DiagnosisRepository repository; // الاعتماد على الواجهة وليس التنفيذ

  DiagnoseImage(this.repository);

  /// يجعل الكلاس قابلاً للاستدعاء كدالة.
  /// يقوم بتمرير الطلب إلى المستودع (Repository).
  Future<Either<Failure, String>> call(File imageFile) async {
    // يمكن إضافة تحقق أساسي هنا إذا لزم الأمر (مثل حجم الملف)
    // استدعاء الدالة في المستودع
    return await repository.diagnoseImage(imageFile);
  }
}