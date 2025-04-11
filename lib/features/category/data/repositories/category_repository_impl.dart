import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/features/category/data/datasources/category_local_datasource.dart';
import 'package:farmersfriendapp/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final categories = await localDataSource.getAllCategories();
      return Right(categories);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Category>> addCategory(Category category) async {
    try {
      final newCategory = await localDataSource.addCategory(category);
      return Right(newCategory);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      final updatedCategory = await localDataSource.updateCategory(category);
      return Right(updatedCategory);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int categoryId) async {
    try {
      await localDataSource.deleteCategory(categoryId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
