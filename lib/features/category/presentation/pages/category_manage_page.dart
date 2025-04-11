import 'dart:async'; // For Timer

import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_text_field.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_message.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/validators/input_validator.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/add_category.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/update_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageCategoryPage extends StatefulWidget {
  final Category? category;

  const ManageCategoryPage({Key? key, this.category}) : super(key: key);

  @override
  State<ManageCategoryPage> createState() => _ManageCategoryPageState();
}

class _ManageCategoryPageState extends State<ManageCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  bool _isLoading = false;
  String? _errorMessage;

  late final AddCategory _addCategory;
  late final UpdateCategory _updateCategory;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.category?.categoryName ?? '');
    _descriptionController =
        TextEditingController(text: widget.category?.categoryDescription ?? '');

    _addCategory = sl.addCategory;
    _updateCategory = sl.updateCategory;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (_isLoading) return;

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final categoryData = Category(
        categoryId: widget.category?.categoryId,
        categoryName: _nameController.text.trim(),
        categoryDescription: _descriptionController.text.trim(),
      );

      try {
        final result = _isEditing
            ? await _updateCategory(categoryData)
            : await _addCategory(categoryData);

        if (!mounted) return;

        result.fold(
          (failure) {
            setState(() {
              _errorMessage = failure.getLocalizedMessage(context);
            });
          },
          (_) {
            _showSuccessAndPop();
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage =
                AppLocalizations.of(context)!.unexpectedError(e.toString());
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessAndPop() {
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.categorySavedSuccessfully),
        backgroundColor: AppConstants.successColor,
        duration: AppConstants.snackBarDuration,
      ),
    );
    Timer(AppConstants.snackBarDuration + const Duration(milliseconds: 100),
        () {
      if (mounted) Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final String title =
        _isEditing ? localizations.editCategory : localizations.addCategory;

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.secondary.withOpacity(0.7),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: _CategoryForm(
            formKey: _formKey,
            nameController: _nameController,
            descriptionController: _descriptionController,
            isLoading: _isLoading,
            errorMessage: _errorMessage,
            isEditing: _isEditing,
            onSavePressed: _saveCategory,
          ),
        ),
      ),
    );
  }
}

class _CategoryForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool isLoading;
  final String? errorMessage;
  final bool isEditing;
  final VoidCallback onSavePressed;

  const _CategoryForm({
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.isLoading,
    required this.errorMessage,
    required this.isEditing,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: nameController,
              label: localizations.categoryName,
              icon: AppConstants.categoryIcon,
              enabled: !isLoading,
              textInputAction: TextInputAction.next,
              validator: (value) => InputValidator.validateGenericRequiredField(
                localizations: localizations,
                value: value,
                emptyErrorMessageProvider: () =>
                    localizations.pleaseEnterCategoryName,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            AppTextField(
              controller: descriptionController,
              label: localizations.description,
              icon: AppConstants.descriptionIcon,
              enabled: !isLoading,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => isLoading ? null : onSavePressed(),
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: AppConstants.largePadding),
            ErrorMessage(message: errorMessage),
            if (errorMessage != null)
              const SizedBox(height: AppConstants.smallPadding),
            AppButton(
              text: isEditing
                  ? localizations.saveChanges
                  : localizations.addCategory,
              onPressed: onSavePressed,
              isLoading: isLoading,
              enabled: !isLoading,
              icon: AppConstants.saveIcon,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
          ],
        ),
      ),
    );
  }
}
