import 'package:dartz/dartz.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';

class DeleteUser {
  final AuthRepository repository;
  DeleteUser(this.repository);

  Future<Either<Failure, void>> call(int userId) async {
    return repository.deleteUser(userId);
  }
}
