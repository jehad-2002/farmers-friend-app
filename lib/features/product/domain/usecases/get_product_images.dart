import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductImages {
  final ProductRepository repository;

  GetProductImages(this.repository);

  Future<Either<Failure, List<ProductImage>>> call(int productId) async {
    return await repository.getImagesForProduct(productId);
  }
}
