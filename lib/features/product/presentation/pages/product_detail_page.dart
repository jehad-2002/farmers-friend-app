import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/image_gallery.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/product/presentation/widgets/product_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductWithImages productWithImages;

  const ProductDetailPage({super.key, required this.productWithImages});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final galleryHeight = (screenHeight * 0.35).clamp(200.0, 350.0);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: productWithImages.product.title,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (productWithImages.images.isNotEmpty)
            SizedBox(
              height: galleryHeight,
              child: ImageGallery(
                images: productWithImages.images,
              ),
            )
          else
            Container(
              height: galleryHeight,
              color: theme.colorScheme.surface.withOpacity(0.1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      color: theme.iconTheme.color?.withOpacity(0.6),
                      size: 60,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      localizations.noImagesAvailable,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.defaultPadding,
              ),
              child: ProductDetailsCard(
                productWithImages: productWithImages,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
