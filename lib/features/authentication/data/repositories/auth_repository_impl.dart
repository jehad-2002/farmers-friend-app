import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:dartz/dartz.dart';
import 'package:farmersfriendapp/core/errors/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> registerUser(User user) async {
    try {
      final registeredUser = await localDataSource.registerUser(user);
      return Right(registeredUser);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginUser(
      String username, String password) async {
    try {
      final user = await localDataSource.loginUser(username, password);
      return Right(user);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(int userId) async {
    try {
      final user = await localDataSource.getUser(userId);
      return Right(user);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      final updatedUser = await localDataSource.updateUser(user);
      return Right(updatedUser);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteUser(int userId) async{
   try {
      await localDataSource.deleteUser(userId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, List<User>>>getAllUsers({String? searchTerm})async {
    try {
      final users = await localDataSource.getAllUsers();
      return Right(users);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
    @override
  Future<Either<Failure, int>> getCurrentUserId() async {
    try {
      final userId = await localDataSource.getUserId();
      return Right(userId!);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
  

}
