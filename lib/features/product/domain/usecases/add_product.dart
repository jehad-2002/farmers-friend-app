import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class AddProduct {
  final ProductRepository repository;
  AddProduct(this.repository);

  Future<Either<Failure, Product>> call(Product product) async {
    return await repository.addProduct(product);
  }
}
