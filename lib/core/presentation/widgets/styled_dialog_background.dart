import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

class StyledDialogBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;

  const StyledDialogBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppConstants.defaultPadding),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = borderRadius ??
        BorderRadius.circular(AppConstants.borderRadiusMedium);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadiusValue,
        gradient: LinearGradient(
          colors: [
            AppConstants.secondaryColor,
            AppConstants.backgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.brownColor.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}

