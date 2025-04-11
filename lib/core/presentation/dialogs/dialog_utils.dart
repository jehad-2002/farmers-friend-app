// lib/core/presentation/dialogs/dialog_utils.dart
import 'package:flutter/material.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogUtils {
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final localizations = AppLocalizations.of(context)!;
    confirmText = confirmText == 'Confirm' ? localizations.ok : confirmText;
    cancelText = cancelText == 'Cancel' ? localizations.cancel : cancelText;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium)),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: AppConstants.defaultFontFamily,
              color: AppConstants.textColorPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(child: content),
          actions: <Widget>[
            TextButton(
              child: Text(
                cancelText,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontFamily: AppConstants.defaultFontFamily,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: AppConstants.whiteColor,
              ),
              child: Text(
                confirmText,
                style: TextStyle(fontFamily: AppConstants.defaultFontFamily),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoadingDialog(BuildContext context,
      {String? message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppConstants.whiteColor.withOpacity(0.85),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium)),
          content: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppConstants.defaultPadding),
            child: LoadingIndicator(
              text: message,
            ),
          ),
        );
      },
    );
  }

  static Future<void> showErrorDialog(BuildContext context,
      {String? title, required String message}) async {
    final localizations = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium)),
          title: Text(
            title ?? localizations.error,
            style: TextStyle(
              fontFamily: AppConstants.defaultFontFamily,
              color: AppConstants.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(fontFamily: AppConstants.defaultFontFamily),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                localizations.ok,
                style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontFamily: AppConstants.defaultFontFamily,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}