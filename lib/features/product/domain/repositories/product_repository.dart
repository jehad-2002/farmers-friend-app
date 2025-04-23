import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();
  Future<Either<Failure, List<Product>>> getProductsByUser(int userId);
  Future<Either<Failure, Product>> addProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(int productId);
  Future<Either<Failure, List<ProductImage>>> getImagesForProduct(
      int productId);
  Future<Either<Failure, ProductImage>> addImageToProduct(
      ProductImage productImage);
  Future<Either<Failure, void>> deleteProductImage(int imageId);
  Future<Either<Failure, List<ProductWithImages>>> getAllProductsWithImages();
  Future<Either<Failure, List<ProductWithImages>>> getProductsWithImagesByUser(
      int userId);
}
