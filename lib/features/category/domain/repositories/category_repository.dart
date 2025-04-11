import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/category.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getAllCategories();
  Future<Either<Failure, Category>> addCategory(Category category);
  Future<Either<Failure, Category>> updateCategory(Category category);
  Future<Either<Failure, void>> deleteCategory(
      int categoryId); 
}
