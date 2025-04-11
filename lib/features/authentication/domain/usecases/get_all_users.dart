import 'package:dartz/dartz.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';

class GetAllUsers {
  final AuthRepository repository;
  GetAllUsers(this.repository);

  // يمكن إضافة وسيطات للبحث والفلترة هنا
  Future<Either<Failure, List<User>>> call({String? searchTerm}) async {
    return repository.getAllUsers(searchTerm: searchTerm);
  }
}
