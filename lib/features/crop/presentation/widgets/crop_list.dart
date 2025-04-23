import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:farmersfriendapp/core/presentation/widgets/confirm_dialog.dart';
import 'package:farmersfriendapp/core/presentation/widgets/empty_list_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';

typedef CropCallback = void Function(Crop crop);

class CropList extends StatelessWidget {
  final List<Crop> crops;
  final CropCallback? onItemTap;
  final CropCallback? onDeleteItemTap;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const CropList({
    Key? key,
    required this.crops,
    this.onItemTap,
    this.onDeleteItemTap,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return ErrorIndicator(message: errorMessage!, onRetry: onRetry);
    }

    if (crops.isEmpty) {
      return EmptyListIndicator(
        message: localizations.noCropsFound,
        icon: AppConstants.cropIcon,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: crops.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: AppConstants.greyColor.withOpacity(0.2),
      ),
      itemBuilder: (context, index) {
        final crop = crops[index];
        return _CropListTile(
          crop: crop,
          onTap: onItemTap,
          onDelete: onDeleteItemTap,
        );
      },
    );
  }
}

class _CropListTile extends StatelessWidget {
  final Crop crop;
  final CropCallback? onTap;
  final CropCallback? onDelete;

  const _CropListTile({
    Key? key,
    required this.crop,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    final actions = <Widget>[];
    if (onTap != null) {
      actions.add(IconButton(
        icon: const Icon(AppConstants.editIcon, size: 22),
        color: theme.primaryColor,
        onPressed: () => onTap!(crop),
      ));
    }
    if (onDelete != null) {
      actions.add(IconButton(
        icon: const Icon(AppConstants.deleteIcon, size: 22),
        color: theme.colorScheme.error,
        onPressed: () => _showDeleteConfirmation(context, localizations),
      ));
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      leading: _CropAvatar(imagePath: crop.cropImage),
      title: Text(
        crop.cropName,
        style: AppStyles.productTitleMedium.copyWith(
          fontFamily: AppConstants.defaultFontFamily,
        ),
      ),
      subtitle: (crop.cropDescription?.isNotEmpty ?? false)
          ? Text(
              crop.cropDescription!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppConstants.textColorSecondary,
                fontFamily: AppConstants.defaultFontFamily,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: onTap != null ? () => onTap!(crop) : null,
      trailing: actions.isNotEmpty
          ? Row(mainAxisSize: MainAxisSize.min, children: actions)
          : null,
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: localizations.confirmDelete,
        content: localizations.deleteCropConfirmation(crop.cropName),
        confirmText: localizations.delete,
        confirmTextColor: Theme.of(context).colorScheme.error,
        onConfirm: () => onDelete!(crop),
      ),
    );
  }
}

class _CropAvatar extends StatelessWidget {
  final String? imagePath;

  const _CropAvatar({Key? key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('assets/')) {
        provider = AssetImage(imagePath!);
      } else if (imagePath!.startsWith('http')) {
        // Network image
        provider = CachedNetworkImageProvider(imagePath!);
      } else {
        // Local file
        try {
          provider = FileImage(File(imagePath!));
        } catch (e) {
          debugPrint('Failed to load file image: $e');
        }
      }
    }

    if (provider != null) {
      return CircleAvatar(
        radius: 25,
        backgroundImage: provider,
        backgroundColor: AppConstants.backgroundColor,
        onBackgroundImageError: (error, stack) {
          debugPrint('Image load error: $error');
        },
      );
    }

    // Fallback icon
    return CircleAvatar(
      radius: 25,
      backgroundColor: AppConstants.accentColor.withOpacity(0.2),
      child: Icon(
        AppConstants.cropIcon,
        color: AppConstants.primaryColor,
        size: 26,
      ),
    );
  }
}
