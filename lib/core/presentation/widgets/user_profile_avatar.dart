import 'dart:io';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final String placeholderAsset;
  final Widget? badge;
  final bool isNetworkImage;

  const UserProfileAvatar({
    super.key,
    required this.imagePath,
    this.radius = 60.0,
    this.borderWidth = 2.0,
    this.borderColor = AppConstants.whiteColor,
    this.placeholderAsset = AppConstants.defaultUserProfileImagePath,
    this.badge,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
final theme = Theme.of(context);
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
color: borderColor == AppConstants.whiteColor
                    ? theme.colorScheme.onBackground
: borderColor,
width: borderWidth,
),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.15),
                  spreadRadius: 0.5,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
              image: DecorationImage(
                image: isNetworkImage
                    ? CachedNetworkImageProvider(imagePath!)
                    : (imagePath != null && imagePath!.isNotEmpty)
                        ? FileImage(File(imagePath!))
                        : AssetImage(placeholderAsset) as ImageProvider<Object>,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              bottom: -4,
              right: -4,
              child: badge!,
            ),
        ],
      ),
    );
  }
}

Widget buildUserTypeBadge(BuildContext context, int accountType) {
  IconData icon;
  Color bgColor;

  switch (accountType) {
    case AppConstants.accountTypeFarmer:
      icon = Icons.cottage_outlined;
      bgColor = AppConstants.primaryColorDark;
      break;
    case AppConstants.accountTypeTrader:
      icon = Icons.shopping_basket_outlined;
      bgColor = AppConstants.brownColor;
      break;
    case AppConstants.accountTypeAgriculturalGuide:
      icon = Icons.lightbulb_outline;
      bgColor = AppConstants.yellowPaleColor;
      break;
    default:
      icon = Icons.person_outline;
      bgColor = AppConstants.greyColor;
  }

  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: bgColor,
      shape: BoxShape.circle,
      border: Border.all(color: AppConstants.whiteColor, width: 1.2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 1.5,
        ),
      ],
    ),
    child: Icon(
      icon,
      color: AppConstants.whiteColor,
      size: 16,
    ),
  );
}
