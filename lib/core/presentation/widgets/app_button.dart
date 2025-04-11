import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final double minWidth;
  final double elevation;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.minWidth = double.infinity,
    this.elevation = AppConstants.elevationLow,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isActuallyEnabled = enabled && !isLoading;

    final Color effectiveBackgroundColor =
        backgroundColor ?? theme.primaryColor; // Use theme's primary color
    final Color effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.onPrimary; // Use theme's onPrimary color
    final Color disabledBackgroundColor =
        theme.disabledColor.withOpacity(0.4); // Use theme's disabled color
    final Color disabledForegroundColor =
        theme.disabledColor.withOpacity(0.6);

    final TextStyle effectiveTextStyle =
        (textStyle ?? theme.textTheme.labelLarge ?? TextStyle()).copyWith(
      color: isActuallyEnabled
          ? effectiveForegroundColor
          : disabledForegroundColor,
      fontSize: 17,
      fontWeight: FontWeight.w500,
      fontFamily: AppConstants.defaultFontFamily, // Use AppConstants font
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: ElevatedButton(
        onPressed: isActuallyEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActuallyEnabled
              ? effectiveBackgroundColor
              : disabledBackgroundColor,
          foregroundColor: isActuallyEnabled
              ? effectiveForegroundColor
              : disabledForegroundColor,
          padding: const EdgeInsets.symmetric(
              vertical: AppConstants.defaultPadding * 0.8,
              horizontal: AppConstants.defaultPadding * 1.4),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          elevation: isActuallyEnabled ? elevation : 0,
          shadowColor: theme.shadowColor.withOpacity(0.15), // Use theme's shadow color
          minimumSize: const Size(double.infinity, 44),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.8,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon,
                        size: effectiveTextStyle.fontSize,
                        color: effectiveTextStyle.color),
                    const SizedBox(width: AppConstants.smallPadding),
                  ],
                  Text(text,
                      style: effectiveTextStyle, textAlign: TextAlign.center),
                ],
              ),
      ),
    );
  }
}

class AppGradients {
  static LinearGradient pageBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppConstants.backgroundColor.withOpacity(0.7),
      AppConstants.secondaryColor.withOpacity(0.9),
    ],
    stops: const [0.1, 0.9],
  );

  static LinearGradient primaryButton = LinearGradient(
    colors: [
      AppConstants.primaryColor,
      AppConstants.primaryColorDark,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

