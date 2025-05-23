import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountTypeDropdown extends StatelessWidget {
  final int? initialValue;
  final ValueChanged<int?> onChanged;
  final FormFieldValidator<int>? validator;
  final bool enabled;
  final String? labelText;

  const AccountTypeDropdown({
    Key? key,
    required this.onChanged,
    this.initialValue = AppConstants.accountTypeFarmer,
    this.validator,
    this.enabled = true,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final List<int> accountTypes = [
      AppConstants.accountTypeFarmer,
      AppConstants.accountTypeTrader,
      AppConstants.accountTypeAgriculturalGuide,
    ];

    final InputDecoration decoration = InputDecoration(
      labelText: labelText ?? localizations.accountType,
      hintText: labelText ?? localizations.accountType,
      hintStyle: TextStyle(
        color: enabled
            ? AppConstants.textColorSecondary.withOpacity(0.6)
            : AppConstants.greyColor,
        fontFamily: AppConstants.defaultFontFamily,
      ),
      prefixIcon: Icon(
        Icons.person_outline,
        color: enabled ? AppConstants.brownColor : AppConstants.greyColor,
        size: 22,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: AppConstants.primaryColorDark,
          width: 1.3,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      filled: true,
      fillColor: enabled
          ? AppConstants.cardBackgroundColor.withOpacity(0.9)
          : theme.disabledColor.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppConstants.defaultPadding * 0.8,
        horizontal: AppConstants.defaultPadding,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: DropdownButtonFormField<int>(
        decoration: decoration,
        value: initialValue,
        items: accountTypes.map((type) {
          return DropdownMenuItem<int>(
            value: type,
            child: Text(
              UserUtils.getAccountTypeName(type, localizations),
              style: AppStyles.descriptionBody,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
        validator: validator ??
            (value) =>
                value == null ? localizations.pleaseSelectAccountType : null,
        disabledHint:
            (initialValue != null && accountTypes.contains(initialValue))
                ? Text(
                    UserUtils.getAccountTypeName(initialValue!, localizations),
                    style: TextStyle(
                      color: AppConstants.textColorSecondary,
                      fontFamily: AppConstants.defaultFontFamily,
                    ),
                  )
                : null,
        isExpanded: true,
      ),
    );
  }
}
