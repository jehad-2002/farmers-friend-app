import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getAllCategories();
  }
}
