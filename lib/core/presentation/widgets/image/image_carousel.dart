import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({
    Key? key,
    required this.images,
    required this.currentImageIndex,
    required this.onThumbnailTap,
  }) : super(key: key);

  final List<dynamic> images;
  final int currentImageIndex;
  final Function(int) onThumbnailTap;

  Widget _buildThumbnail(String imagePath, int index) {
    final isCurrentImage = currentImageIndex == index;
    return GestureDetector(
      onTap: () => onThumbnailTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: isCurrentImage
                ? AppConstants.primaryColorDark
                : Colors.transparent,
            width: isCurrentImage ? 2 : 0,
          ),
          boxShadow: isCurrentImage
              ? [
                  BoxShadow(
                    color: AppConstants.primaryColorDark.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            height: 90,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox();
    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return _buildThumbnail(images[index].imagePath, index);
      },
      options: CarouselOptions(
        height: 90,
        viewportFraction: 0.23,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          onThumbnailTap(index);
        },
      ),
    );
  }
}
