import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final Function(Locale) onLocaleSelected;
  final TextStyle? titleStyle;
  final TextStyle? listTileTextStyle;

  const LanguageSelectionDialog({
    Key? key,
    required this.onLocaleSelected,
    this.titleStyle,
    this.listTileTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      backgroundColor: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose your language/اختر لغتك',
              textAlign: TextAlign.center,
              style: titleStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    fontSize: 19,
                    color: theme.textTheme.titleLarge?.color,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppConstants.defaultFontFamily,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ListTile(
              title: Text(
                "English",
                style: listTileTextStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                      fontFamily: AppConstants.defaultFontFamily,
                    ),
              ),
              onTap: () {
                onLocaleSelected(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "العربية",
                style: listTileTextStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                      fontFamily: AppConstants.defaultFontFamily,
                    ),
              ),
              onTap: () {
                onLocaleSelected(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
