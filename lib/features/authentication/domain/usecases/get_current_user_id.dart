// lib/features/authentication/domain/usecases/get_current_user_id.dart
import 'package:dartz/dartz.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';

/// حالة استخدام لجلب ID المستخدم المسجل دخوله حاليًا.
class GetCurrentUserId {
  final AuthRepository repository;

  GetCurrentUserId(this.repository);

  /// يستدعي المستودع لجلب ID المستخدم الحالي.
  /// لا يتطلب أي وسيطات.
  /// يعيد `int?` (يمكن أن يكون null) في حالة النجاح.
  Future<Either<Failure, int?>> call() async {
    return await repository.getCurrentUserId();
  }
}