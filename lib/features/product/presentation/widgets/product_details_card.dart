import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
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
    final product = productWithImages.product;

    return Card(
      elevation: AppConstants.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      color: AppConstants.cardBackgroundColor,
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
                  style: AppStyles.priceLarge.copyWith(
                    fontFamily: AppConstants.defaultFontFamily,
                  ),
                ),
                Text(
                  AppDateUtils.formatSimpleDate(context, product.dateAdded),
                  style: AppStyles.dateStyle.copyWith(
                    fontFamily: AppConstants.defaultFontFamily,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              product.title,
              style: AppStyles.productTitleLarge.copyWith(
                fontFamily: AppConstants.defaultFontFamily,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              product.description ?? localizations.noDescriptionAvailable,
              style: AppStyles.descriptionBody.copyWith(
                fontFamily: AppConstants.defaultFontFamily,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            Divider(
              color: AppConstants.greyColor,
              thickness: 0.8,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColorDark,
                    foregroundColor: AppConstants.whiteColor,
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
                    style: AppStyles.buttonTextStyle.copyWith(
                      fontFamily: AppConstants.defaultFontFamily,
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
