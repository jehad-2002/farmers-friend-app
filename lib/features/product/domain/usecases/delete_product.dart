import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Either<Failure, void>> call(int productId) async {
    return await repository.deleteProduct(productId);
  }
}
