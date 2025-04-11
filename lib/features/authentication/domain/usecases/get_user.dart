import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetUser {
  final AuthRepository repository;

  GetUser(this.repository);

  Future<Either<Failure, User>> call(int userId) async {
    return await repository.getUser(userId);
  }
}
