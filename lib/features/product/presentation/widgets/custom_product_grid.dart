import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/product/presentation/widgets/custom_product_card.dart';
import 'package:flutter/material.dart';

typedef ProductWithImagesCallback = void Function(
    ProductWithImages productWithImages);
typedef ProductCallback = void Function(Product product);

class CustomProductGrid extends StatelessWidget {
  final List<ProductWithImages> productsWithImages;
  final bool showAdminActions;
  final ProductWithImagesCallback? onProductTap;
  final ProductCallback? onEditTap;
  final ProductCallback? onDeleteTap;

  const CustomProductGrid({
    super.key,
    required this.productsWithImages,
    required this.showAdminActions,
    this.onProductTap,
    this.onEditTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding / 2,
        vertical: AppConstants.smallPadding,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppConstants.defaultPadding / 2,
        mainAxisSpacing: AppConstants.defaultPadding / 2,
      ),
      itemCount: productsWithImages.length,
      itemBuilder: (context, index) {
        final productWithImagesItem = productsWithImages[index];
        return CustomProductCard(
          key: ValueKey(productWithImagesItem.product.productId),
          productWithImages: productWithImagesItem,
          showAdminActions: showAdminActions,
          onTap: onProductTap,
          onEditTap: onEditTap,
          onDeleteConfirm: onDeleteTap,
        );
      },
    );
  }
}
