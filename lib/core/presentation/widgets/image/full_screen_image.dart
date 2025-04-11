import 'dart:io';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImage extends StatefulWidget {
  final List<dynamic> images;
  final int initialIndex;

  const FullScreenImage({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = (widget.initialIndex >= 0 && widget.initialIndex < widget.images.length)
        ? widget.initialIndex
        : 0;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ImageProvider _getImageProvider(dynamic imageSource) {
    String imagePath;

    if (imageSource is String) {
      imagePath = imageSource;
    } else if (imageSource is guidelineImage) {
      imagePath = imageSource.imagePath;
    } else if (imageSource is GuidelineImage) {
      imagePath = imageSource.imagePath;
    } else {
      print("FullScreenImage: Unknown image source type: ${imageSource.runtimeType}");
      return const AssetImage(AppConstants.defaultguidelineImagePath);
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImageProvider(imagePath);
    } else if (imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        print("FullScreenImage: File not found at path: $imagePath");
        return const AssetImage(AppConstants.defaultguidelineImagePath);
      }
    } else {
      print("FullScreenImage: Empty image path provided.");
      return const AssetImage(AppConstants.defaultguidelineImagePath);
    }
  }

  PhotoViewGalleryPageOptions _buildGalleryItem(BuildContext context, int index) {
    final imageSource = widget.images[index];
    final imageProvider = _getImageProvider(imageSource);
    final theme = Theme.of(context);

    final heroTag = imageSource is String ? imageSource : imageSource.hashCode.toString();

    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      minScale: PhotoViewComputedScale.contained * 0.9,
      maxScale: PhotoViewComputedScale.covered * 2,
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(Icons.error, color: theme.colorScheme.error, size: 50),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.images.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("No Images")),
        body: const Center(child: Text("No images to display.")),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.background.withOpacity(0.9),
      appBar: CustomAppBar(
        title: "${_currentPage + 1} / ${widget.images.length}",
      ),
      body: PhotoViewGallery.builder(
        backgroundDecoration: BoxDecoration(color: theme.colorScheme.surface),
        itemCount: widget.images.length,
        builder: _buildGalleryItem,
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}