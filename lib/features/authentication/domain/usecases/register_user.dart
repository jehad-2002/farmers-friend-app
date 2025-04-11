import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, User>> call(User user) async {
    return await repository.registerUser(user);
  }
}

