import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteProductImage {
  final ProductRepository repository;

  DeleteProductImage(this.repository);

  Future<Either<Failure, void>> call(int imageId) async {
    return await repository.deleteProductImage(imageId);
  }
}
