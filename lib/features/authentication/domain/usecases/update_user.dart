import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateUser {
  final AuthRepository repository;
  UpdateUser(this.repository);

  Future<Either<Failure, User>> call(User user) async {
    return await repository.updateUser(user);
  }
}
