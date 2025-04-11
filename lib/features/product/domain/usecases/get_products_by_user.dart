import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductsByUser {
  final ProductRepository repository;

  GetProductsByUser(this.repository);

  Future<Either<Failure, List<Product>>> call(int userId) async {
    return await repository.getProductsByUser(userId);
  }
}
