import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/empty_list_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/delete_category.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/get_all_categories.dart';
import 'package:farmersfriendapp/features/category/presentation/pages/category_manage_page.dart';
import 'package:farmersfriendapp/features/category/presentation/widgets/category_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({Key? key}) : super(key: key);

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Category>? _categories;
  String? _errorMessage;
  bool _isLoading = true;

  late final GetAllCategories _getAllCategories;
  late final DeleteCategory _deleteCategory;

  @override
  void initState() {
    super.initState();
    _getAllCategories = sl.getAllCategories;
    _deleteCategory = sl.deleteCategory;
    _loadCategories();
  }

  Future<void> _loadCategories({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final result = await _getAllCategories();

      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() {
            _errorMessage = failure.getLocalizedMessage(context);
            _categories = null;
          });
        },
        (categories) {
          setState(() {
            _categories = categories;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              AppLocalizations.of(context)!.unexpectedError(e.toString());
          _categories = null;
        });
      }
    } finally {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateManageCategory({Category? category}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ManageCategoryPage(category: category),
      ),
    );

    if (result == true && mounted) {
      _loadCategories(showLoading: false);
    }
  }

  Future<void> _handleDeleteCategory(Category category) async {
    try {
      final result = await _deleteCategory(category.categoryId!);
      if (!mounted) return;

      result.fold((failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.getLocalizedMessage(context)),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }, (_) {
        setState(() {
          _categories?.removeWhere((c) => c.categoryId == category.categoryId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppConstants.successColor,
              content: Text(
                  AppLocalizations.of(context)!.categoryDeletedSuccessfully)),
        );
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppConstants.errorColor,
              content: Text(
                  AppLocalizations.of(context)!.unexpectedError(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: localizations.manageCategories),
      body: _buildBody(context, localizations),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        tooltip: localizations.addCategory,
        onPressed: () => _navigateManageCategory(),
        child: const Icon(AppConstants.addIcon),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations localizations) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_errorMessage != null) {
      return ErrorIndicator(
        message: _errorMessage!,
        onRetry: _loadCategories,
      );
    }

    if (_categories == null || _categories!.isEmpty) {
      return EmptyListIndicator(
        message: localizations.noCategoriesFound,
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadCategories(showLoading: false),
      color: theme.colorScheme.primary,
      child: CategoryList(
        categories: _categories!,
        onItemTap: (category) => _navigateManageCategory(category: category),
        onDeleteItemTap: _handleDeleteCategory,
      ),
    );
  }
}
