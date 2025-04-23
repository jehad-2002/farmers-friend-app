import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryFilterDropdown extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onChanged;
  final bool enabled;

  const CategoryFilterDropdown({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final allCategoriesName = localizations.allCategories;

    final InputDecoration decoration = InputDecoration(
      hintText: localizations.filterByCategory,
      hintStyle: TextStyle(
          color: enabled
              ? AppConstants.textColorSecondary
              : AppConstants.greyColor.withOpacity(0.6),
          fontFamily: AppConstants.defaultFontFamily),
      prefixIcon: Icon(
          AppConstants.filterListIcon,
          color: enabled ? AppConstants.brownColor : AppConstants.greyColor,
          size: 22),
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
        value: selectedCategoryId,
        items: categories.map((category) {
          return DropdownMenuItem<int>(
            value: category.categoryId,
            child: Text(
              category.categoryId == -1
                  ? allCategoriesName
                  : category.categoryName,
              style: TextStyle(
                fontFamily: AppConstants.defaultFontFamily,
                color: AppConstants.textColorPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
        disabledHint: selectedCategoryId != null &&
                categories.any((c) => c.categoryId == selectedCategoryId)
            ? Text(categories
                        .firstWhere((c) => c.categoryId == selectedCategoryId)
                        .categoryId ==
                    -1
                ? allCategoriesName
                : categories
                    .firstWhere((c) => c.categoryId == selectedCategoryId)
                    .categoryName)
            : null,
        isExpanded: true,
      ),
    );
  }
}
