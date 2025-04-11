import 'package:farmersfriendapp/core/enums/filter_type.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharedFilterBar extends StatefulWidget {
  final FilterType currentFilter;
  final Function(FilterType? filterType) onFilterChanged;

  const SharedFilterBar({
    super.key,
    this.currentFilter = FilterType.none,
    required this.onFilterChanged,
  });

  @override
  State<SharedFilterBar> createState() => _SharedFilterBarState();
}

class _SharedFilterBarState extends State<SharedFilterBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return PopupMenuButton<FilterType>(
      icon: Icon(AppConstants.filterListIcon,
          color: theme.iconTheme.color?.withOpacity(0.7)),
      tooltip: localizations.filter,
      onSelected: widget.onFilterChanged,
      initialValue: widget.currentFilter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterType>>[
        PopupMenuItem<FilterType>(
          value: FilterType.none,
          child: Row(
            children: [
              Text(localizations.noFilter,
                  style: TextStyle(
                      fontFamily: AppConstants.defaultFontFamily,
                      color: theme.textTheme.bodyMedium?.color)),
              if (widget.currentFilter == FilterType.none)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check,
                      color: theme.colorScheme.primary, size: 20),
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<FilterType>(
          value: FilterType.sortByDateNewestFirst,
          child: Row(
            children: [
              Text(localizations.sortNewestFirst,
                  style: TextStyle(
                      fontFamily: AppConstants.defaultFontFamily,
                      color: theme.textTheme.bodyMedium?.color)),
              if (widget.currentFilter == FilterType.sortByDateNewestFirst)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check,
                      color: theme.colorScheme.primary, size: 20),
                ),
            ],
          ),
        ),
        PopupMenuItem<FilterType>(
          value: FilterType.sortByDateOldestFirst,
          child: Row(
            children: [
              Text(localizations.sortOldestFirst,
                  style: TextStyle(
                      fontFamily: AppConstants.defaultFontFamily,
                      color: theme.textTheme.bodyMedium?.color)),
              if (widget.currentFilter == FilterType.sortByDateOldestFirst)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check,
                      color: theme.colorScheme.primary, size: 20),
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<FilterType>(
          value: FilterType.filterByCrop,
          child: Row(
            children: [
              Text(localizations.filterByCrop,
                  style: TextStyle(
                      fontFamily: AppConstants.defaultFontFamily,
                      color: theme.textTheme.bodyMedium?.color)),
              if (widget.currentFilter == FilterType.filterByCrop)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check,
                      color: theme.colorScheme.primary, size: 20),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

