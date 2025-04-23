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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              AppConstants.errorOutlineIcon,
              color: AppConstants.errorColor.withOpacity(0.8),
              size: 55,
            ),
            const SizedBox(height: AppConstants.defaultPadding / 2),
            Text(
              localizations.errorOccurred,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstants.errorColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppConstants.defaultFontFamily),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.textColorSecondary.withOpacity(0.9),
                  fontFamily: AppConstants.defaultFontFamily),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.mediumPadding),
              AppButton(
                text: localizations.retry,
                onPressed: onRetry!,
                backgroundColor: AppConstants.secondaryColor,
                foregroundColor: AppConstants.primaryColorDark,
                minWidth: 110,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

