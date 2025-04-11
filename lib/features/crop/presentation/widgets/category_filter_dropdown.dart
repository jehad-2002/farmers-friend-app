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
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: enabled
            ? theme.hintColor
            : theme.disabledColor.withOpacity(0.6),
        fontFamily: theme.textTheme.bodyMedium?.fontFamily,
      ),
      prefixIcon: Icon(
        AppConstants.filterListIcon,
        color: enabled ? theme.iconTheme.color : theme.disabledColor,
        size: 22,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: enabled
          ? theme.colorScheme.surface.withOpacity(0.9)
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
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: theme.textTheme.bodyMedium?.fontFamily,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
        disabledHint: selectedCategoryId != null &&
                categories.any((c) => c.categoryId == selectedCategoryId)
            ? Text(
                categories.firstWhere((c) => c.categoryId == selectedCategoryId)
                        .categoryId ==
                    -1
                    ? allCategoriesName
                    : categories
                        .firstWhere((c) => c.categoryId == selectedCategoryId)
                        .categoryName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                  fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                ),
              )
            : null,
        isExpanded: true,
      ),
    );
  }
}
