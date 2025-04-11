import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/features/product/data/datasources/product_local_datasource.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final products = await localDataSource.getAllProducts();
      return Right(products);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByUser(int userId) async {
    try {
      final products = await localDataSource.getProductsByUser(userId);
      return Right(products);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Product>> addProduct(Product product) async {
    try {
      final newProduct = await localDataSource.addProduct(product);
      return Right(newProduct);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      final updatedProduct = await localDataSource.updateProduct(product);
      return Right(updatedProduct);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int productId) async {
    try {
      await localDataSource.deleteProduct(productId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<guidelineImage>>> getImagesForProduct(
      int productId) async {
    try {
      final productImages =
          await localDataSource.getImagesForProduct(productId);
      return Right(productImages);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, guidelineImage>> addImageToProduct(
      guidelineImage productImage) async {
    try {
      final newProductImage =
          await localDataSource.addImageToProduct(productImage);
      return Right(newProductImage);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProductImage(int imageId) async {
    try {
      await localDataSource.deleteProductImage(imageId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductWithImages>>>
      getAllProductsWithImages() async {
    try {
      final productsWithImages =
          await localDataSource.getAllProductsWithImages();
      return Right(productsWithImages);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductWithImages>>> getProductsWithImagesByUser(
      int userId) async {
    try {
      final productsWithImages =
          await localDataSource.getProductsWithImagesByUser(userId);
      return Right(productsWithImages);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
