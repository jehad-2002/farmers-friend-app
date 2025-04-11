import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;
  final Color? titleColor;
  final Color? valueColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const InfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.titleColor,
    this.valueColor,
    this.titleStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.iconTheme.color; // Use theme's icon color
    final effectiveTitleColor = titleColor ?? theme.textTheme.titleSmall?.color; // Use theme's titleSmall color
    final effectiveValueColor = valueColor ?? theme.textTheme.bodyMedium?.color; // Use theme's bodyMedium color

    final effectiveTitleStyle = titleStyle ??
        theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: effectiveTitleColor,
          fontFamily: AppConstants.defaultFontFamily, // Use AppConstants font
        ) ??
        TextStyle(
          fontWeight: FontWeight.w600,
          color: effectiveTitleColor,
          fontFamily: AppConstants.defaultFontFamily,
          fontSize: 14,
        );

    final effectiveValueStyle = valueStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: effectiveValueColor,
          fontFamily: AppConstants.defaultFontFamily, // Use AppConstants font
        ) ??
        TextStyle(
          color: effectiveValueColor,
          fontFamily: AppConstants.defaultFontFamily,
          fontSize: 14,
        );

    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: AppConstants.smallPadding / 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: effectiveIconColor, size: 20),
          const SizedBox(width: AppConstants.defaultPadding / 1.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: effectiveTitleStyle,
                ),
                const SizedBox(height: 1),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: effectiveValueStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

