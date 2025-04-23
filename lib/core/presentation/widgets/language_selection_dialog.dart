// lib/core/presentation/widgets/language_selection_dialog.dart
import 'package:farmersfriendapp/core/utils/app_constants.dart'; // لـ borderRadius فقط
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // لاستخدام الترجمة

/// مربع حوار لاختيار لغة التطبيق.
class LanguageSelectionDialog extends StatelessWidget {
  /// دالة تُستدعى عند اختيار لغة جديدة.
  final Function(Locale) onLocaleSelected;

  const LanguageSelectionDialog({
    Key? key,
    required this.onLocaleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // استخدام أنماط الحوار من السمة
    final titleStyle = theme.dialogTheme.titleTextStyle ?? theme.textTheme.titleLarge;
    final listTileTextStyle = theme.textTheme.titleMedium; // أو أي نمط مناسب آخر

    return Dialog(
      // استخدام شكل الحوار من السمة
      shape: theme.dialogTheme.shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      backgroundColor: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultPadding, horizontal: AppConstants.smallPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min, // لجعل العمود يأخذ أقل مساحة ممكنة
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
              child: Text(
                localizations.chooseLanguage, // استخدام النص المترجم
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
            ),
            const Divider(), // فاصل بصري
            ListTile(
              title: Text(
                "English", // يمكن ترك اسم اللغة كما هو أو ترجمته إذا أردت
                style: listTileTextStyle,
              ),
              onTap: () {
                onLocaleSelected(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "العربية", // يمكن ترك اسم اللغة كما هو أو ترجمته إذا أردت
                style: listTileTextStyle,
              ),
              onTap: () {
                onLocaleSelected(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            // أضف لغات أخرى هنا بنفس الطريقة إذا لزم الأمر
          ],
        ),
      ),
    );
  }
}