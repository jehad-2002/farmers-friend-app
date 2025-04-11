import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class AddProductImage {
  final ProductRepository repository;
  AddProductImage(this.repository);
  Future<Either<Failure, guidelineImage>> call(guidelineImage productImage) async {
    return await repository.addImageToProduct(productImage);
  }
}
