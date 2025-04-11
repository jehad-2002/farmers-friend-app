import 'dart:io';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/core/presentation/widgets/image/full_screen_image.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageGallery extends StatefulWidget {
  final List<dynamic> images;
  final int initialIndex;

  const ImageGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  ImageProvider _getImageProvider(dynamic image) {
    if (image is String) {
      if (image.startsWith('http://') || image.startsWith('https://')) {
        return CachedNetworkImageProvider(image);
      } else {
        return FileImage(File(image));
      }
    } else if (image is guidelineImage) {
      if (image.imagePath.startsWith('http://') ||
          image.imagePath.startsWith('https://')) {
        return CachedNetworkImageProvider(image.imagePath);
      } else {
        return FileImage(File(image.imagePath));
      }
    } else {
      return const AssetImage(AppConstants.defaultguidelineImagePath);
    }
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final image = widget.images[index];
    final imageProvider = _getImageProvider(image);
    final theme = Theme.of(context);

    return PhotoViewGalleryPageOptions.customChild(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImage(
                images: widget.images,
                initialIndex: index,
              ),
            ),
          );
        },
        child: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor, // Use theme's scaffold background color
          ),
          imageProvider: imageProvider,
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          errorBuilder: (context, event, stackTrace) {
            return Center(
              child: Icon(
                Icons.error,
                color: theme.colorScheme.error, // Use theme's error color
              ),
            );
          },
          heroAttributes: PhotoViewHeroAttributes(tag: image.toString()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: _buildItem,
            itemCount: widget.images.length,
            backgroundDecoration: BoxDecoration(
              color: theme.colorScheme.background, // Use theme's background color
            ),
            pageController: _pageController,
            onPageChanged: _onPageChanged,
            scrollDirection: Axis.horizontal,
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary, // Use theme's primary color
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "${_currentIndex + 1} / ${widget.images.length}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary, // Use theme's onPrimary color
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: Icon(Icons.close, color: theme.colorScheme.onPrimary), // Use theme's onPrimary color
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
