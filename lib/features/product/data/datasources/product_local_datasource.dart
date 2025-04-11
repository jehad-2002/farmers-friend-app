import 'package:farmersfriendapp/core/database/database_helper.dart';
import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getAllProducts();
  Future<List<Product>> getProductsByUser(int userId);
  Future<Product> addProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(int productId);
  Future<List<guidelineImage>> getImagesForProduct(int productId);
  Future<guidelineImage> addImageToProduct(guidelineImage productImage);
  Future<void> deleteProductImage(int imageId);
  Future<List<ProductWithImages>> getAllProductsWithImages();
  Future<List<ProductWithImages>> getProductsWithImagesByUser(int userId);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper dbHelper;

  ProductLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final maps = await dbHelper.queryAllRows('Products');
      return maps.map((map) => Product.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get all products: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByUser(int userId) async {
    try {
      final maps = await dbHelper.query(
        'Products',
        where: 'UserID = ?',
        whereArgs: [userId],
      );
      return maps.map((map) => Product.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get products by user: $e');
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    try {
      final productId = await dbHelper.insert('Products', product.toMap());
      return product.copyWith(productId: productId);
    } catch (e) {
      throw DatabaseException('Failed to add product: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      await dbHelper.update(
        'Products',
        product.toMap(),
        where: 'ProductID = ?',
        whereArgs: [product.productId],
      );
      return product;
    } catch (e) {
      throw DatabaseException('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      await dbHelper.delete(
        'Products',
        where: 'ProductID = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete product: $e');
    }
  }

  @override
  Future<List<guidelineImage>> getImagesForProduct(int productId) async {
    try {
      final maps = await dbHelper.query('ProductImages',
          where: 'ProductID = ?', whereArgs: [productId]);

      return maps.map((e) => guidelineImage.fromMap(e)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get product images: $e');
    }
  }

  @override
  Future<guidelineImage> addImageToProduct(guidelineImage productImage) async {
    try {
      final imageId =
          await dbHelper.insert('ProductImages', productImage.toMap());
      return productImage.copyWith(imageId: imageId);
    } catch (e) {
      throw DatabaseException('Failed to add image to product: $e');
    }
  }

  @override
  Future<void> deleteProductImage(int imageId) async {
    try {
      await dbHelper.delete(
        'ProductImages',
        where: 'ImageID = ?',
        whereArgs: [imageId],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete product image: $e');
    }
  }

  @override
  Future<List<ProductWithImages>> getAllProductsWithImages() async {
    final List<ProductWithImages> productsWithImages = [];

    final products = await getAllProducts();
    for (final product in products) {
      final images = await getImagesForProduct(product.productId!);
      productsWithImages
          .add(ProductWithImages(product: product, images: images));
    }
    return productsWithImages;
  }

  @override
  Future<List<ProductWithImages>> getProductsWithImagesByUser(
      int userId) async {
    final List<ProductWithImages> productsWithImages = [];

    final products = await getProductsByUser(userId);
    for (final product in products) {
      final images = await getImagesForProduct(product.productId!);
      productsWithImages
          .add(ProductWithImages(product: product, images: images));
    }
    return productsWithImages;
  }
}
