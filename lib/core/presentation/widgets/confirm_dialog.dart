import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color? confirmTextColor;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final effectiveConfirmText =
        (confirmText == 'Confirm' ? localizations.ok : confirmText);
    final effectiveCancelText =
        (cancelText == 'Cancel' ? localizations.cancel : cancelText);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      backgroundColor: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface, // Use theme's surface color
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontFamily: AppConstants.defaultFontFamily,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface, // Use theme's onSurface color
        ),
      ),
      content: Text(
        content,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontFamily: AppConstants.defaultFontFamily,
          color: theme.colorScheme.onSurface.withOpacity(0.9), // Use theme's onSurface color
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          child: Text(
            effectiveCancelText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary, // Use theme's secondary color
              fontFamily: AppConstants.defaultFontFamily,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmTextColor ?? theme.colorScheme.primary, // Use theme's primary color
            foregroundColor: theme.colorScheme.onPrimary, // Use theme's onPrimary color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            ),
          ),
          child: Text(
            effectiveConfirmText,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.defaultFontFamily,
              color: theme.colorScheme.onPrimary, // Use theme's onPrimary color
            ),
          ),
        ),
      ],
    );
  }
}


