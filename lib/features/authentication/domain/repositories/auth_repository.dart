// lib/features/authentication/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/user.dart'; // مسار User model

/// الواجهة المجردة لمستودع المصادقة وإدارة المستخدمين.
/// تحدد العمليات التي يجب أن توفرها طبقة البيانات.
abstract class AuthRepository {
  /// تسجيل مستخدم جديد.
  Future<Either<Failure, User>> registerUser(User user);

  /// تسجيل دخول مستخدم موجود.
  Future<Either<Failure, User>> loginUser(String username, String password);

  /// جلب بيانات مستخدم معين بواسطة ID.
  Future<Either<Failure, User>> getUser(int userId);

  /// تحديث بيانات مستخدم موجود.
  Future<Either<Failure, User>> updateUser(User user);

  /// جلب قائمة بجميع المستخدمين مع إمكانية البحث.
  Future<Either<Failure, List<User>>> getAllUsers({String? searchTerm});

  /// حذف مستخدم معين بواسطة ID (عملية إدارية غالبًا).
  Future<Either<Failure, void>> deleteUser(int userId);

  // يمكنك إضافة عمليات أخرى هنا مثل:
  // Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, int?>> getCurrentUserId();
}