import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/empty_list_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/get_all_categories.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/delete_crop.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/get_all_crops.dart';
import 'package:farmersfriendapp/features/crop/presentation/pages/crop_manage_page.dart';
import 'package:farmersfriendapp/features/crop/presentation/widgets/category_filter_dropdown.dart';
import 'package:farmersfriendapp/features/crop/presentation/widgets/crop_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CropListPage extends StatefulWidget {
  const CropListPage({super.key});

  @override
  State<CropListPage> createState() => _CropListPageState();
}

class _CropListPageState extends State<CropListPage> {
  List<Crop>? _allCrops;
  List<Category> _categories = [];
  int? _selectedCategoryId = -1;
  bool _isLoading = true;
  String? _errorMessage;

  late final GetAllCrops _getAllCrops;
  late final GetAllCategories _getAllCategories;
  late final DeleteCrop _deleteCrop;

  late final Category _allCategoriesOption;

  @override
  void initState() {
    super.initState();
    _getAllCrops = sl.getAllCrops;
    _getAllCategories = sl.getAllCategories;
    _deleteCrop = sl.deleteCrop;
    _allCategoriesOption = const Category(
        categoryId: -1, categoryName: "All", categoryDescription: '');
    _loadInitialData();
  }

  Future<void> _loadInitialData({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final results = await Future.wait([
        _getAllCategories(),
        _getAllCrops(),
      ]);

      if (!mounted) return;

      final categoriesResult = results[0] as dynamic;
      List<Category> fetchedCategories = [];
      categoriesResult.fold(
        (failure) => throw failure,
        (categories) => fetchedCategories = categories,
      );

      final cropsResult = results[1] as dynamic;
      cropsResult.fold((failure) => throw failure, (crops) {
        setState(() {
          _allCrops = crops;
        });
      });

      setState(() {
        _categories = [_allCategoriesOption, ...fetchedCategories];
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          if (e is Failure) {
            _errorMessage = e.getLocalizedMessage(context);
          } else {
            _errorMessage =
                AppLocalizations.of(context)!.unexpectedError(e.toString());
          }
          _allCrops = null;
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

  List<Crop> _getFilteredCrops() {
    if (_allCrops == null) return [];
    if (_selectedCategoryId == -1) {
      return _allCrops!;
    } else {
      return _allCrops!
          .where((crop) => crop.categoryId == _selectedCategoryId)
          .toList();
    }
  }

  Future<void> _navigateManageCrop({Crop? crop}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => ManageCropPage(crop: crop)),
    );
    if (result == true && mounted) {
      _loadInitialData(showLoading: false);
    }
  }

  Future<void> _handleDeleteCrop(Crop crop) async {
    try {
      final result = await _deleteCrop(crop.cropId!);
      if (!mounted) return;

      result.fold((failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(failure.getLocalizedMessage(context)),
              backgroundColor: AppConstants.errorColor),
        );
      }, (_) {
        setState(() {
          _allCrops?.removeWhere((c) => c.cropId == crop.cropId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppConstants.successColor,
              content:
                  Text(AppLocalizations.of(context)!.cropDeletedSuccessfully)),
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
    if (_categories.isNotEmpty && _categories[0].categoryName == "All") {
      _categories[0] = Category(
          categoryId: -1,
          categoryName: localizations.allCategories,
          categoryDescription: '');
    }

    return Scaffold(
      appBar: CustomAppBar(title: localizations.manageCrops),
      body: Column(
        children: [
          if (!_isLoading && _errorMessage == null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: CategoryFilterDropdown(
                categories: _categories,
                selectedCategoryId: _selectedCategoryId,
                enabled: !_isLoading,
                onChanged: (value) {
                  if (value != _selectedCategoryId) {
                    setState(() => _selectedCategoryId = value);
                  }
                },
              ),
            ),
          Expanded(child: _buildBody(context, localizations)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        tooltip: localizations.addCrop,
        onPressed: _isLoading ? null : () => _navigateManageCrop(),
        child: const Icon(AppConstants.addIcon),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations localizations) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const LoadingIndicator(isCentered: true);
    }
    if (_errorMessage != null) {
      return ErrorIndicator(message: _errorMessage!, onRetry: _loadInitialData);
    }

    final filteredCrops = _getFilteredCrops();

    if (filteredCrops.isEmpty) {
      final message = _selectedCategoryId == -1
          ? localizations.noCropsFound
          : localizations.noCropsInCategoryFound;

      return EmptyListIndicator(
        message: message,
        icon: AppConstants.cropIcon,
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadInitialData(showLoading: false),
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.background,
      child: CropList(
        crops: filteredCrops,
        onItemTap: (crop) => _navigateManageCrop(crop: crop),
        onDeleteItemTap: _handleDeleteCrop,
      ),
    );
  }
}
