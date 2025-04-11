import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<Either<Failure, void>> call(int categoryId) async {
    return await repository.deleteCategory(categoryId);
  }
}
