import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef CategoryCallback = void Function(Category category);

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final CategoryCallback? onItemTap;
  final CategoryCallback? onDeleteItemTap;

  const CategoryList({
    super.key,
    required this.categories,
    this.onItemTap,
    this.onDeleteItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: AppConstants.greyColor.withOpacity(0.3),
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColorLight,
            child: Icon(AppConstants.categoryIcon,
                color: Theme.of(context).primaryColorDark),
          ),
          title: Text(category.categoryName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: AppConstants.defaultFontFamily,
                  fontWeight: FontWeight.w500)),
          subtitle: category.categoryDescription!.isNotEmpty
              ? Text(
                  category.categoryDescription!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textColorSecondary,
                      fontFamily: AppConstants.defaultFontFamily),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          onTap: onItemTap != null ? () => onItemTap!(category) : null,
          trailing: onDeleteItemTap != null
              ? IconButton(
                  icon: Icon(AppConstants.deleteIcon,
                      color: Theme.of(context).colorScheme.error),
                  tooltip: AppLocalizations.of(context)?.delete,
                  onPressed: () => _confirmDeletion(context, category),
                )
              : null,
        );
      },
    );
  }

  void _confirmDeletion(BuildContext context, Category category) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.confirmDelete),
        content: Text(
          localizations.deleteCategoryConfirmation(category.categoryName),
          style: TextStyle(fontFamily: AppConstants.defaultFontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations.cancel,
                style: TextStyle(color: AppConstants.textColorSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onDeleteItemTap!(category);
            },
            child: Text(localizations.delete,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
