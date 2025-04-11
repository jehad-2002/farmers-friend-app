import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, User>> call(String username, String password) async {
    return await repository.loginUser(username, password);
  }
}

