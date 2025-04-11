import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategorySelectionDropdown extends StatefulWidget {
  final int? initialValue;
  final ValueChanged<int?> onChanged;
  final FormFieldValidator<int>? validator;
  final bool enabled;
  final String? labelText;

  const CategorySelectionDropdown({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.labelText,
  });

  @override
  State<CategorySelectionDropdown> createState() =>
      _CategorySelectionDropdownState();
}

class _CategorySelectionDropdownState extends State<CategorySelectionDropdown> {
  List<Category>? _categories;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    if (mounted && !_isLoading) setState(() => _isLoading = true);
    _error = null;

    try {
      final result = await sl.getAllCategories();
      if (!mounted) return;

      result.fold(
        (failure) => setState(() => _error = failure.message),
        (categories) => setState(() => _categories = categories),
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _buildDecoration(
      BuildContext context, AppLocalizations localizations, String label) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: widget.enabled ? theme.colorScheme.primary : theme.disabledColor,
        fontFamily: theme.textTheme.bodyMedium?.fontFamily,
      ),
      prefixIcon: Icon(
        AppConstants.categoryIcon,
        color: widget.enabled ? theme.colorScheme.primary : theme.disabledColor,
        size: 22,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusCircular),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: widget.enabled
          ? theme.colorScheme.surface.withOpacity(0.8)
          : theme.disabledColor.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppConstants.defaultPadding * 0.8,
        horizontal: AppConstants.defaultPadding * 0.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final effectiveLabel = widget.labelText ?? localizations.category;

    if (_isLoading) {
      return InputDecorator(
        decoration:
            _buildDecoration(context, localizations, effectiveLabel).copyWith(
          hintText: localizations.loadingCategories,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
          ),
        ),
        child: const SizedBox(
          height: 20,
          child: Align(
            alignment: Alignment.centerLeft,
            child: LoadingIndicator(isCentered: true),
          ),
        ),
      );
    }

    if (_error != null) {
      return InputDecorator(
        decoration:
            _buildDecoration(context, localizations, effectiveLabel).copyWith(
          errorText: localizations.errorLoadingCategories,
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                localizations.errorLoadingCategories,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 22),
              tooltip: localizations.retry,
              color: theme.disabledColor,
              onPressed: widget.enabled ? _fetchCategories : null,
            ),
          ],
        ),
      );
    }

    if (_categories == null || _categories!.isEmpty) {
      return InputDecorator(
        decoration: _buildDecoration(context, localizations, effectiveLabel),
        child: Text(
          localizations.noCategoriesFound,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color,
            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
          ),
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: widget.initialValue,
      items: _categories!.map((category) {
        return DropdownMenuItem<int>(
          value: category.categoryId,
          child: Text(
            category.categoryName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: theme.textTheme.bodyMedium?.fontFamily,
            ),
          ),
        );
      }).toList(),
      onChanged: widget.enabled ? widget.onChanged : null,
      validator: widget.validator ??
          (value) => value == null ? localizations.pleaseSelectCategory : null,
      decoration: _buildDecoration(context, localizations, effectiveLabel),
      disabledHint: widget.initialValue != null
          ? Text(
              _categories
                      ?.firstWhere(
                        (c) => c.categoryId == widget.initialValue,
                        orElse: () => Category(
                          categoryId: -1,
                          categoryName: "",
                          categoryDescription: "",
                        ),
                      )
                      .categoryName ??
                  '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
                fontFamily: theme.textTheme.bodyMedium?.fontFamily,
              ),
            )
          : null,
      isExpanded: true,
    );
  }
}
