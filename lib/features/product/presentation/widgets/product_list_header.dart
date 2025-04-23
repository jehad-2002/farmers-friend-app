import 'package:farmersfriendapp/core/enums/filter_type.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_search_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/shared_filter_bar.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ويدجت لعرض شريط البحث وزر الفلترة
class ProductListHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final FilterType currentFilter;
  final ValueChanged<FilterType?> onFilterChanged;
  final bool isLoading;
  final AppLocalizations localizations;

  const ProductListHeader({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.isLoading,
    required this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding),
      child: Row(
        children: [
          // حقل البحث
          Expanded(
            child: CustomSearchBar(
              controller: searchController,
              onChanged: onSearchChanged,
              hintText: localizations.searchProducts,
              enabled: !isLoading, // تعطيل أثناء التحميل
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          // زر الفلترة/الترتيب
          SharedFilterBar(
            currentFilter: currentFilter,
            onFilterChanged: onFilterChanged,
          ),
        ],
      ),
    );
  }
}