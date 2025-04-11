import 'dart:io';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/core/models/guideline_with_images.dart';
import 'package:farmersfriendapp/core/presentation/widgets/confirm_dialog.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

typedef GuidelineCallback = void Function(Guideline guideline);

class GuidelineCard extends StatelessWidget {
  final GuidelineWithImages guidelineWithImages;
  final bool showAdminActions;
  final GuidelineCallback? onTap;
  final GuidelineCallback? onEditTap;
  final GuidelineCallback? onDeleteConfirm;

  const GuidelineCard({
    super.key,
    required this.guidelineWithImages,
    required this.showAdminActions,
    this.onTap,
    this.onEditTap,
    this.onDeleteConfirm,
  });

  ImageProvider _getImageProvider(List<GuidelineImage> images) {
    if (images.isNotEmpty && images.first.imagePath.isNotEmpty) {
      final String imagePath = images.first.imagePath;
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return CachedNetworkImageProvider(imagePath);
      } else {
        try {
          final file = File(imagePath);
          if (file.existsSync()) {
            return FileImage(file);
          } else {
            print("GuidelineCard: File does not exist at path '$imagePath'");
            return const AssetImage(AppConstants.defaultGuidelineImagePath);
          }
        } catch (e) {
          print(
              "GuidelineCard: Error creating FileImage from path '$imagePath': $e");
          return const AssetImage(AppConstants.defaultGuidelineImagePath);
        }
      }
    } else {
      return const AssetImage(AppConstants.defaultGuidelineImagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final guideline = guidelineWithImages.guideline;
    final imageProvider = _getImageProvider(guidelineWithImages.images);

    return Card(
      elevation: AppConstants.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap != null ? () => onTap!(guideline) : null,
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
                            ? Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : child,
                    errorBuilder: (context, error, stack) {
                      return Container(
                        color: theme.colorScheme.surface.withOpacity(0.1),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: theme.iconTheme.color?.withOpacity(0.6),
                          size: 40,
                        ),
                      );
                    },
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
                          color: Colors.black.withOpacity(0.65),
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
                                onPressed: () => onEditTap!(guideline),
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
                                  guideline,
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
                    guideline.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  if (guideline.publicationDate != null &&
                      guideline.publicationDate!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      AppDateUtils.formatSimpleDate(
                        context,
                        guideline.publicationDate!,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
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
    Guideline guideline,
  ) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: localizations.confirmDelete,
        content: localizations.deleteGuidelineConfirmation(guideline.title),
        confirmText: localizations.delete,
        confirmTextColor: theme.colorScheme.error,
        onConfirm: () {
          if (onDeleteConfirm != null) onDeleteConfirm!(guideline);
        },
      ),
    );
  }
}
