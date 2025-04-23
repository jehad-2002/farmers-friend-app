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
    } else if (image is ProductImage) {
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

    // هنا نستخدم customChild لنضيف GestureDetector
    return PhotoViewGalleryPageOptions.customChild(
      child: GestureDetector(
        onTap: () {
          // عند الضغط على الصورة
          // مثال: إغلاق المعرض والعودة مع النتيجة
          Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImage(images: widget.images, initialIndex: index),));
        },
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: AppConstants.brownColor),
          imageProvider: imageProvider,
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          errorBuilder: (context, event, stackTrace) {
            return const Center(
              child: Icon(Icons.error, color: Colors.red),
            );
          },
          heroAttributes: PhotoViewHeroAttributes(tag: image.toString()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: _buildItem,
            itemCount: widget.images.length,
            backgroundDecoration:  BoxDecoration(
              color: AppConstants.accentColor,
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
              color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "${_currentIndex + 1} / ${widget.images.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
