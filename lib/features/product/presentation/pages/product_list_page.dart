import 'package:farmersfriendapp/core/enums/filter_type.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/presentation/widgets/crop_selection_dropdown.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_search_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/empty_list_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/shared_filter_bar.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/delete_product.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_all_products_with_images.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_products_with_images_by_user.dart';
import 'package:farmersfriendapp/features/product/presentation/pages/manage_product_page.dart';
import 'package:farmersfriendapp/features/product/presentation/pages/product_detail_page.dart';
import 'package:farmersfriendapp/features/product/presentation/widgets/custom_product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductListPage extends StatefulWidget {
  final int? userId;

  const ProductListPage({Key? key, this.userId}) : super(key: key);

  bool get isUserView => userId != null && userId! > 0;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<ProductWithImages> _allProducts = [];
  List<ProductWithImages> _displayProducts = [];
  bool _isLoading = true;
  String? _errorMessage;
  FilterType _currentFilterType = FilterType.none;
  int? _selectedCropIdForFilter;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  late final GetAllProductsWithImages _getAllProductsWithImages;
  late final GetProductsWithImagesByUser _getProductsWithImagesByUser;
  late final DeleteProduct _deleteProduct;

  @override
  void initState() {
    super.initState();
    _resolveUseCases();
    _loadInitialData();
  }

  void _resolveUseCases() {
    _getAllProductsWithImages = sl.getAllProductsWithImages;
    _getProductsWithImagesByUser = sl.getProductsWithImagesByUser;
    _deleteProduct = sl.deleteProduct;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final result = widget.isUserView
          ? await _getProductsWithImagesByUser(widget.userId!)
          : await _getAllProductsWithImages();

      if (!mounted) return;

      result.fold((failure) => throw failure, (products) {
        _allProducts = products;
        _applyFiltersAndSort();
      });
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = (e is Failure)
              ? e.getLocalizedMessage(context)
              : AppLocalizations.of(context)!.errorLoadingData;
          _allProducts = [];
          _displayProducts = [];
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFiltersAndSort() {
    if (!mounted) return;
    List<ProductWithImages> result = List.from(_allProducts);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where((pwi) => pwi.product.title.toLowerCase().contains(query))
          .toList();
    }

    if (_currentFilterType == FilterType.filterByCrop &&
        _selectedCropIdForFilter != null) {
      result = result
          .where((pwi) => pwi.product.cropId == _selectedCropIdForFilter)
          .toList();
    }

    switch (_currentFilterType) {
      case FilterType.sortByDateNewestFirst:
        result.sort(
            (a, b) => (b.product.dateAdded).compareTo(a.product.dateAdded));
        break;
      case FilterType.sortByDateOldestFirst:
        result.sort(
            (a, b) => (a.product.dateAdded).compareTo(b.product.dateAdded));
        break;
      default:
        result.sort(
            (a, b) => (b.product.dateAdded).compareTo(a.product.dateAdded));
        break;
    }

    setState(() => _displayProducts = result);
  }

  void _onSearchChanged(String query) {
    if (_searchQuery != query) {
      setState(() => _searchQuery = query);
      _applyFiltersAndSort();
    }
  }

  void _onFilterTypeChanged(FilterType? filterType) {
    final newFilter = filterType ?? FilterType.none;
    if (newFilter != _currentFilterType) {
      setState(() {
        _currentFilterType = newFilter;
        _applyFiltersAndSort();
      });
    }
  }

  void _onCropSelectedForFilter(int? cropId) {
    if (_currentFilterType == FilterType.filterByCrop) {
      setState(() {
        _selectedCropIdForFilter = cropId;
        _applyFiltersAndSort();
      });
    }
  }

  Future<void> _navigateManageProduct({Product? product}) async {
    if (!widget.isUserView) return;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ManageProductPage(product: product),
      ),
    );
    if (result == true && mounted) {
      _loadInitialData(showLoading: false);
    }
  }

  void _navigateToDetail(ProductWithImages productWithImages) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(productWithImages: productWithImages),
      ),
    );
  }

  Future<void> _handleDeleteProduct(Product product) async {
    if (!widget.isUserView || product.productId == null) return;
    try {
      final result = await _deleteProduct(product.productId!);
      if (!mounted) return;
      result.fold(
        (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(f.getLocalizedMessage(context)),
            backgroundColor: AppConstants.errorColor)),
        (_) {
          setState(() {
            _allProducts.removeWhere(
                (pwi) => pwi.product.productId == product.productId);
            _applyFiltersAndSort();
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.productDeletedSuccessfully),
              backgroundColor: AppConstants.successColor));
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.unexpectedError(e.toString())),
            backgroundColor: AppConstants.errorColor));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: widget.isUserView
          ? CustomAppBar(
              title: localizations.myProducts,
              iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
              backgroundColor: theme.colorScheme.primary,
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => _loadInitialData(showLoading: false),
        color: theme.colorScheme.primary,
        backgroundColor: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      hintText: localizations.searchProducts,
                      enabled: !_isLoading,
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  SharedFilterBar(
                    currentFilter: _currentFilterType,
                    onFilterChanged: _onFilterTypeChanged,
                  ),
                ],
              ),
            ),
            if (_currentFilterType == FilterType.filterByCrop && !_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: AppConstants.smallPadding / 2,
                ),
                child: CropSelectionDropdown(
                  initialValue: _selectedCropIdForFilter,
                  labelText: localizations.filterByCrop,
                  enabled: !_isLoading,
                  onChanged: _onCropSelectedForFilter,
                  validator: null,
                ),
              ),
            Expanded(
              child: _buildContentBody(context, localizations),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.isUserView
          ? FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              tooltip: localizations.addProduct,
              onPressed: _isLoading ? null : () => _navigateManageProduct(),
              child: const Icon(AppConstants.addIcon),
            )
          : null,
    );
  }

  Widget _buildContentBody(
      BuildContext context, AppLocalizations localizations) {

    if (_isLoading) {
      return const LoadingIndicator(isCentered: true);
    }
    if (_errorMessage != null) {
      return ErrorIndicator(
        message: _errorMessage!,
        onRetry: _loadInitialData,
      );
    }

    if (_displayProducts.isEmpty) {
      final message = _searchQuery.isNotEmpty ||
              (_currentFilterType == FilterType.filterByCrop &&
                  _selectedCropIdForFilter != null)
          ? localizations.noMatchingProductsFound
          : (widget.isUserView
              ? localizations.noOwnProductsFound
              : localizations.noProductsFound);
      return EmptyListIndicator(
        message: message,
        icon: AppConstants.productIcon,
      );
    }

    return CustomProductGrid(
      productsWithImages: _displayProducts,
      showAdminActions: widget.isUserView,
      onProductTap: _navigateToDetail,
      onEditTap: (product) {
        _navigateManageProduct(product: product);
      },
      onDeleteTap: _handleDeleteProduct,
    );
  }
}
