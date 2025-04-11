import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateCategory {
  final CategoryRepository repository;
  UpdateCategory(this.repository);
  Future<Either<Failure, Category>> call(Category category) async {
    return await repository.updateCategory(category);
  }
}
