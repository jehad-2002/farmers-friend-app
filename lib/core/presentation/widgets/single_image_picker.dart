import 'dart:io';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

class SingleImagePicker extends StatelessWidget {
  final String? initialImagePath;
  final File? selectedImageFile;
  final VoidCallback onPickImage;
  final VoidCallback? onRemoveImage;
  final double radius;
  final bool enabled;
  final String placeholderAsset;

  const SingleImagePicker({
    super.key,
    this.initialImagePath,
    this.selectedImageFile,
    required this.onPickImage,
    this.onRemoveImage,
    this.radius = 55.0,
    this.enabled = true,
    this.placeholderAsset = AppConstants.defaultCropImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ImageProvider imageProvider;
    bool hasImage = false;
    if (selectedImageFile != null) {
      imageProvider = FileImage(selectedImageFile!);
      hasImage = true;
    } else if (initialImagePath != null && initialImagePath!.isNotEmpty) {
      if (initialImagePath!.startsWith('http')) {
        imageProvider = NetworkImage(initialImagePath!);
      } else {
        try {
          imageProvider = FileImage(File(initialImagePath!));
        } catch (e) {
          imageProvider = AssetImage(placeholderAsset);
        }
      }
      hasImage = true;
    } else {
      imageProvider = AssetImage(placeholderAsset);
      hasImage = false;
    }

    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          GestureDetector(
            onTap: enabled ? onPickImage : null,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: theme.disabledColor.withOpacity(0.1),
              backgroundImage: imageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                print("Error loading background image: $exception");
              },
              child: !hasImage && enabled
                  ? Icon(
                      AppConstants.addAPhotoIcon,
                      size: radius * 0.6,
                      color: theme.iconTheme.color?.withOpacity(0.7),
                    )
                  : null,
            ),
          ),
          if (hasImage && onRemoveImage != null && enabled)
            Positioned(
              child: Material(
                type: MaterialType.transparency,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onRemoveImage,
                  child: Container(
                    padding:
                        const EdgeInsets.all(AppConstants.smallPadding / 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppConstants.closeIcon,
                      size: radius * 0.3,
                      color: AppConstants.whiteColor,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
