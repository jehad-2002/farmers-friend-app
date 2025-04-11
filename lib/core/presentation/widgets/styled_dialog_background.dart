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
    final theme = Theme.of(context);
    final borderRadiusValue = borderRadius ?? BorderRadius.circular(AppConstants.borderRadiusMedium);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadiusValue,
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary.withOpacity(0.8), // Use theme's secondary color
            theme.colorScheme.surface, // Use theme's surface color
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.15), // Use theme's shadow color
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

