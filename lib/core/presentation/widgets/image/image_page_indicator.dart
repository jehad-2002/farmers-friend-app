import 'package:flutter/material.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';

class ImagePageIndicator extends StatelessWidget {
  const ImagePageIndicator({
    super.key,
    required this.count,
    required this.currentImageIndex,
  });

  final int count;
  final int currentImageIndex;

  Widget _buildCustomPageIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentImageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin:
              const EdgeInsets.symmetric(horizontal: AppConstants.smallMargin),
          width: isActive ? 10 : 7,
          height: isActive ? 10 : 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppConstants.primaryColorDark
                : AppConstants.greyColor,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppConstants.primaryColorDark.withOpacity(0.3),
                      blurRadius: 3,
                      spreadRadius: 0.3,
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCustomPageIndicator(context);
  }
}

