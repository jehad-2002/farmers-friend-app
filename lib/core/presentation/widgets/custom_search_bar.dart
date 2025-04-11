import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final bool enabled;
  final VoidCallback? onClear;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.enabled = true,
    this.onClear,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButtonVisibility);
    _updateClearButtonVisibility();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButtonVisibility);
    super.dispose();
  }

  void _updateClearButtonVisibility() {
    if (!mounted) return;
    final shouldShow = widget.controller.text.isNotEmpty;
    if (shouldShow != _showClearButton) {
      setState(() {
        _showClearButton = shouldShow;
      });
    }
  }

  void _clearSearch() {
    if (!widget.enabled) return;
    widget.controller.clear();
    widget.onChanged('');
    widget.onClear?.call();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isEnabled = widget.enabled;

    final effectiveBorderColor = isEnabled
        ? theme.dividerColor.withOpacity(0.7)
        : theme.disabledColor.withOpacity(0.4);
    final effectiveIconColor = isEnabled
        ? theme.iconTheme.color
        : theme.disabledColor;
    final effectiveFillColor = isEnabled
        ? theme.colorScheme.surface.withOpacity(0.8)
        : theme.disabledColor.withOpacity(0.1);
    final effectiveTextColor = isEnabled
        ? theme.textTheme.bodyLarge?.color?.withOpacity(0.9)
        : theme.textTheme.bodyMedium?.color?.withOpacity(0.7);
    final effectiveHintColor = theme.hintColor.withOpacity(0.6);

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: isEnabled,
      style: TextStyle(
        color: effectiveTextColor,
        fontSize: 16,
        fontFamily: AppConstants.defaultFontFamily,
      ),
      cursorColor: theme.colorScheme.primary,
      textInputAction: TextInputAction.search,
      onSubmitted: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText ?? localizations.search,
        hintStyle: TextStyle(
          color: effectiveHintColor,
          fontFamily: AppConstants.defaultFontFamily,
          fontSize: 16,
        ),
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppConstants.defaultPadding * 0.8,
          horizontal: AppConstants.defaultPadding,
        ),
        prefixIcon: Icon(
          AppConstants.searchIcon,
          color: effectiveIconColor,
          size: 23,
        ),
        suffixIcon: _showClearButton && isEnabled
            ? IconButton(
                icon: const Icon(AppConstants.clearIcon),
                iconSize: 20,
                color: effectiveIconColor,
                tooltip: localizations.clear,
                onPressed: _clearSearch,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          borderSide: BorderSide(
            color: effectiveBorderColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          borderSide: BorderSide(
            color: effectiveBorderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          borderSide: BorderSide(
            color: theme.disabledColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        errorBorder: null,
        focusedErrorBorder: null,
      ),
    );
  }
}
