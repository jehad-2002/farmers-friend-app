
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';

class ProductWithImages {
  final Product product;
  final List<ProductImage> images;

  ProductWithImages({required this.product, required this.images});
}

