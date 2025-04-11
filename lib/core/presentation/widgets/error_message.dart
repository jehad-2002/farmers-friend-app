import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String? message;
  final EdgeInsetsGeometry padding;
  final TextAlign textAlign;

  const ErrorMessage({
    super.key,
    required this.message,
    this.padding =
        const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveErrorStyle = AppStyles.errorText(context).copyWith(
      fontFamily: theme.textTheme.bodyMedium?.fontFamily,
      color: theme.colorScheme.error.withOpacity(0.9), // Use theme's error color
    );

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppConstants.errorOutlineIcon,
            color: theme.colorScheme.error.withOpacity(0.8), // Use theme's error color
            size: effectiveErrorStyle.fontSize! * 1.1,
          ),
          const SizedBox(width: AppConstants.smallPadding / 2.5),
          Flexible(
            child: Text(
              message!,
              style: effectiveErrorStyle,
              textAlign: textAlign,
            ),
          ),
        ],
      ),
    );
  }
}

