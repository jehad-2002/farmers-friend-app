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
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
      title: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: AppConstants.defaultFontFamily,
              fontWeight: FontWeight.w600)),
      content: Text(content,
          style: TextStyle(fontFamily: AppConstants.defaultFontFamily)),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          child: Text(
            effectiveCancelText,
            style: TextStyle(
                color: AppConstants.textColorSecondary,
                fontFamily: AppConstants.defaultFontFamily),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                confirmTextColor ?? theme.primaryColorDark,
            foregroundColor: AppConstants.whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusSmall)),
          ),
          child: Text(
            effectiveConfirmText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.defaultFontFamily),
          ),
        ),
      ],
    );
  }
}


