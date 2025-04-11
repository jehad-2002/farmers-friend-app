import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorIndicator extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorIndicator({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              AppConstants.errorOutlineIcon,
              color: theme.colorScheme.error.withOpacity(0.8), // Use theme's error color
              size: 55,
            ),
            const SizedBox(height: AppConstants.defaultPadding / 2),
            Text(
              localizations.errorOccurred,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error, // Use theme's error color
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.defaultFontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9), // Use theme's bodyMedium color
                fontFamily: AppConstants.defaultFontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.mediumPadding),
              AppButton(
                text: localizations.retry,
                onPressed: onRetry!,
                backgroundColor: theme.colorScheme.secondary, // Use theme's secondary color
                foregroundColor: theme.colorScheme.onSecondary, // Use theme's onSecondary color
                minWidth: 110,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

