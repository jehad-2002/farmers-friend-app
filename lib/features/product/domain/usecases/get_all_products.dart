import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:dartz/dartz.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getAllProducts();
  }
}
