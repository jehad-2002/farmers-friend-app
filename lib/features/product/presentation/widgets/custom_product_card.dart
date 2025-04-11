import 'dart:io';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:farmersfriendapp/core/presentation/widgets/confirm_dialog.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

typedef ProductCallback = void Function(Product product);
typedef ProductWithImagesCallback = void Function(
    ProductWithImages productWithImages);

class CustomProductCard extends StatelessWidget {
  final ProductWithImages productWithImages;
  final bool showAdminActions;
  final ProductWithImagesCallback? onTap;
  final ProductCallback? onEditTap;
  final ProductCallback? onDeleteConfirm;

  const CustomProductCard({
    super.key,
    required this.productWithImages,
    required this.showAdminActions,
    this.onTap,
    this.onEditTap,
    this.onDeleteConfirm,
  });

  ImageProvider _getImageProvider(List<guidelineImage> images) {
    if (images.isNotEmpty && images.first.imagePath.isNotEmpty) {
      final String imagePath = images.first.imagePath;
      if (imagePath.startsWith('http')) {
        return CachedNetworkImageProvider(imagePath);
      } else {
        try {
          final f = File(imagePath);
          if (f.existsSync()) return FileImage(f);
        } catch (e) {
          print("ProdCard Img File Err: $e");
        }
      }
    }
    return const AssetImage(AppConstants.defaultguidelineImagePath);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final product = productWithImages.product;
    final imageProvider = _getImageProvider(productWithImages.images);

    return Card(
      elevation: AppConstants.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap != null ? () => onTap!(productWithImages) : null,
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        (imageProvider is CachedNetworkImageProvider &&
                                loadingProgress != null)
                            ? const Center(child: LoadingIndicator())
                            : child,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      AppConstants.defaultguidelineImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (showAdminActions &&
                      (onEditTap != null || onDeleteConfirm != null))
                    Positioned(
                      bottom: AppConstants.smallPadding / 2,
                      right: AppConstants.smallPadding / 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.smallPadding * 0.75,
                          vertical: AppConstants.smallPadding / 3,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (onEditTap != null)
                              _buildAdminActionButton(
                                context: context,
                                icon: AppConstants.editIcon,
                                tooltip: localizations.edit,
                                color: theme.colorScheme.onSurface,
                                onPressed: () => onEditTap!(product),
                              ),
                            if (onEditTap != null && onDeleteConfirm != null)
                              const SizedBox(
                                width: AppConstants.smallPadding / 2,
                              ),
                            if (onDeleteConfirm != null)
                              _buildAdminActionButton(
                                context: context,
                                icon: AppConstants.deleteIcon,
                                tooltip: localizations.delete,
                                color: theme.colorScheme.error,
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  localizations,
                                  product,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.smallPadding + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${product.price.toStringAsFixed(0)} ${localizations.currency}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActionButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: color,
        padding: const EdgeInsets.all(6.0),
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        splashRadius: 18,
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations localizations,
    Product product,
  ) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: localizations.confirmDelete,
        content: localizations.deleteProductConfirmation(product.title),
        confirmText: localizations.delete,
        confirmTextColor: theme.colorScheme.error,
        onConfirm: () {
          if (onDeleteConfirm != null) onDeleteConfirm!(product);
        },
      ),
    );
  }
}
