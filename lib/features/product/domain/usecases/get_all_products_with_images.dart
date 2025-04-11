import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllProductsWithImages {
  final ProductRepository repository;

  GetAllProductsWithImages(this.repository);

  Future<Either<Failure, List<ProductWithImages>>> call() async {
    return await repository.getAllProductsWithImages();
  }
}
