import 'dart:io';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnNewFilesAdded = void Function(List<File> files);
typedef OnExistingImageRemoved = void Function(dynamic existingImageSource);
typedef OnNewFileRemoved = void Function(File file);
typedef ImagePreviewBuilder = Widget Function(
    BuildContext context, dynamic imageSource, bool isExisting);

class MultiImagePicker extends StatelessWidget {
  final List<dynamic> initialExistingImages;
  final List<File> newlySelectedFiles;
  final OnNewFilesAdded onNewFilesAdded;
  final OnExistingImageRemoved onExistingImageRemoved;
  final OnNewFileRemoved onNewFileRemoved;
  final ImagePreviewBuilder itemBuilder;
  final int maxImages;
  final bool enabled;
  final String? placeholderImage;
  final ButtonStyle? addButtonStyle;
  final Size imagePreviewSize;
  final double itemSpacing;

  const MultiImagePicker({
    super.key,
    this.initialExistingImages = const [],
    this.newlySelectedFiles = const [],
    required this.onNewFilesAdded,
    required this.onExistingImageRemoved,
    required this.onNewFileRemoved,
    required this.itemBuilder,
    this.maxImages = 5,
    this.enabled = true,
    this.placeholderImage,
    this.addButtonStyle,
    this.imagePreviewSize = const Size(80, 80),
    this.itemSpacing = AppConstants.defaultMargin,
  });

  int get _currentImageCount =>
      initialExistingImages.length + newlySelectedFiles.length;
  bool get _canAddMore => _currentImageCount < maxImages;

  Future<void> _pickImages(BuildContext context) async {
    if (!enabled || !_canAddMore) return;
    final picker = ImagePicker();
    final localizations = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(localizations.chooseFromGallery),
                  onTap: () async {
                    Navigator.pop(context);
                    final int remainingSlots = maxImages - _currentImageCount;
                    final pickedFiles = await picker.pickMultiImage(
                        imageQuality: 80, maxWidth: 1000, maxHeight: 1000);

                    if (pickedFiles.isNotEmpty && context.mounted) {
                      final currentNewPaths =
                          newlySelectedFiles.map((f) => f.path).toSet();
                      final filesToAdd = pickedFiles
                          .where(
                              (xFile) => !currentNewPaths.contains(xFile.path))
                          .map((xFile) => File(xFile.path))
                          .take(remainingSlots)
                          .toList();

                      if (filesToAdd.isNotEmpty) {
                        onNewFilesAdded(filesToAdd);
                      }
                    }
                  }),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(localizations.takePhoto),
                onTap: () async {
                  Navigator.pop(context);
                  if (_canAddMore && context.mounted) {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                      maxWidth: 1000,
                      maxHeight: 1000,
                    );
                    if (pickedFile != null) {
                      final newFile = File(pickedFile.path);
                      final currentNewPaths =
                          newlySelectedFiles.map((f) => f.path).toSet();
                      if (!currentNewPaths.contains(newFile.path) &&
                          _currentImageCount < maxImages) {
                        onNewFilesAdded([newFile]);
                      }
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> displayItems = [
      ...initialExistingImages,
      ...newlySelectedFiles
    ];
    final int totalRenderItems = displayItems.length + (_canAddMore ? 1 : 0);

    return SizedBox(
      height: imagePreviewSize.height + (itemSpacing / 2),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalRenderItems,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
        itemBuilder: (context, index) {
          if (_canAddMore && index == displayItems.length) {
            return _buildAddImageButton(context);
          }
          final itemSource = displayItems[index];
          final bool isExistingItem = index < initialExistingImages.length;
          return _buildImagePreviewTile(context, itemSource, isExistingItem);
        },
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final ButtonStyle defaultStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      backgroundColor: enabled
          ? AppConstants.primaryColor.withOpacity(0.6)
          : theme.disabledColor.withOpacity(0.2),
      foregroundColor:
          enabled ? AppConstants.primaryColorDark : AppConstants.greyColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
      side: BorderSide(
          color: enabled
              ? AppConstants.primaryColorDark.withOpacity(0.5)
              : AppConstants.greyColor.withOpacity(0.5),
          width: 1),
      elevation: 0,
    );
    final effectiveStyle = addButtonStyle ?? defaultStyle;

    return Tooltip(
      message: enabled ? localizations.addImage : "",
      child: Container(
        width: imagePreviewSize.width,
        height: imagePreviewSize.height,
        margin: EdgeInsets.only(right: itemSpacing),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: enabled ? AppConstants.primaryColorDark : Colors.grey,
            width: 1,
          ),
        ),
        child: ElevatedButton(
          style: effectiveStyle,
          onPressed: enabled ? () => _pickImages(context) : null,
          child: Icon(
            AppConstants.addAPhotoIcon,
            size: imagePreviewSize.width * 0.45,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreviewTile(
      BuildContext context, dynamic imageSource, bool isExisting) {
    return Container(
      width: imagePreviewSize.width,
      height: imagePreviewSize.height,
      margin: EdgeInsets.only(right: itemSpacing),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Stack(
          fit: StackFit.expand,
          children: [
            itemBuilder(context, imageSource, isExisting),
            if (enabled)
              Positioned(
                right: 2,
                top: 2,
                child: Material(
                  color: AppConstants.errorColor.withOpacity(0.7),
                  type: MaterialType.circle,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => isExisting
                        ? onExistingImageRemoved(imageSource)
                        : onNewFileRemoved(imageSource as File),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        AppConstants.closeIcon,
                        size: 14,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

