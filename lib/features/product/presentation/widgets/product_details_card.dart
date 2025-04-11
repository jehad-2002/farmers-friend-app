import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/date_utils.dart';
import 'package:farmersfriendapp/features/authentication/presentation/widgets/user_data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef ProductCallback = void Function(Product product);
typedef ProductWithImagesCallback = void Function(
    ProductWithImages productWithImages);

class ProductDetailsCard extends StatelessWidget {
  final ProductWithImages productWithImages;

  const ProductDetailsCard({
    Key? key,
    required this.productWithImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final product = productWithImages.product;

    return Card(
      elevation: AppConstants.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${product.price.toStringAsFixed(0)} ${localizations.currency}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  AppDateUtils.formatSimpleDate(context, product.dateAdded),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              product.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              product.description ?? localizations.noDescriptionAvailable,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            Divider(
              color: theme.dividerColor,
              thickness: 0.8,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                      vertical: AppConstants.smallPadding * 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusCircular,
                      ),
                    ),
                  ),
                  onPressed: () {
                    showUserDataDialog(context, product);
                  },
                  icon: const Icon(
                    AppConstants.infoOutlineIcon,
                    size: 20,
                  ),
                  label: Text(
                    localizations.sellerInfo,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
