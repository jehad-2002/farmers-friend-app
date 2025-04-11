import 'dart:io';
import 'package:flutter/material.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';

class MainImageView extends StatelessWidget {
  const MainImageView({
    Key? key,
    required this.pageController,
    required this.images,
    required this.currentImageIndex,
    required this.scaleAnimation,
    required this.onPageChanged,
    required this.onTap,
  }) : super(key: key);

  final PageController pageController;
  final List<dynamic> images;
  final int currentImageIndex;
  final Animation<double> scaleAnimation;
  final void Function(int) onPageChanged;
  final void Function(int) onTap;

  Widget _buildMainImage(String imagePath, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Hero(
          tag: imagePath,
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox();
    return PageView.builder(
      controller: pageController,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildMainImage(images[index].imagePath, index);
      },
      onPageChanged: onPageChanged,
    );
  }
}

