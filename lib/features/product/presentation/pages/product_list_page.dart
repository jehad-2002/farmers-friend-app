import 'package:farmersfriendapp/core/enums/filter_type.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
// Widgets moved to separate files or kept as private widgets below
import 'package:farmersfriendapp/features/product/presentation/widgets/product_list_header.dart';
import 'package:farmersfriendapp/features/product/presentation/widgets/crop_filter_section.dart';
import 'package:farmersfriendapp/features/product/presentation/widgets/product_list_content.dart';
// Core Widgets remain
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
// Service Locator and Constants
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
// Use Cases
import 'package:farmersfriendapp/features/product/domain/usecases/delete_product.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_all_products_with_images.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_products_with_images_by_user.dart';
// Navigation Targets
import 'package:farmersfriendapp/features/product/presentation/pages/manage_product_page.dart';
import 'package:farmersfriendapp/features/product/presentation/pages/product_detail_page.dart';
// Product Grid Widget
// Flutter and Localization
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductListPage extends StatefulWidget {
  final int? userId;

  const ProductListPage({Key? key, this.userId}) : super(key: key);

  // لتحديد ما إذا كانت الصفحة تعرض منتجات المستخدم الحالي أم كل المنتجات
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

  // Use Cases instances
  late final GetAllProductsWithImages _getAllProductsWithImages;
  late final GetProductsWithImagesByUser _getProductsWithImagesByUser;
  late final DeleteProduct _deleteProduct;

  @override
  void initState() {
    super.initState();
    _resolveUseCases(); // الحصول على الـ Use Cases من Service Locator
    _loadInitialData(); // تحميل البيانات الأولية
  }

  // الحصول على الـ Use Cases المطلوبة
  void _resolveUseCases() {
    _getAllProductsWithImages = sl.getAllProductsWithImages;
    _getProductsWithImagesByUser = sl.getProductsWithImagesByUser;
    _deleteProduct = sl.deleteProduct;
  }

  @override
  void dispose() {
    _searchController.dispose(); // تحرير الـ Controller عند إغلاق الصفحة
    super.dispose();
  }

  // دالة تحميل البيانات (إما كل المنتجات أو منتجات المستخدم)
  Future<void> _loadInitialData({bool showLoading = true}) async {
    if (!mounted) return; // التأكد من أن الـ Widget مازال موجوداً

    if (showLoading) {
      setState(() {
        _isLoading = true; // عرض مؤشر التحميل
        _errorMessage = null; // مسح أي رسالة خطأ سابقة
      });
    }

    try {
      // تحديد الـ Use Case المناسب بناءً على `isUserView`
      final result = widget.isUserView
          ? await _getProductsWithImagesByUser(widget.userId!)
          : await _getAllProductsWithImages();

      if (!mounted) return; // التحقق مرة أخرى بعد العملية غير المتزامنة

      result.fold(
        (failure) => throw failure, // رمي الخطأ لمعالجته في catch
        (products) {
          _allProducts = products; // تخزين كل المنتجات التي تم جلبها
          _applyFiltersAndSort(); // تطبيق الفلاتر والترتيب لعرض المنتجات
        },
      );
      if (mounted) {
        setState(() {
          _errorMessage = null; // مسح رسالة الخطأ في حالة النجاح
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // تحديد رسالة الخطأ المناسبة
          _errorMessage = (e is Failure)
              ? e.getLocalizedMessage(context)
              : AppLocalizations.of(context)!.errorLoadingData;
          _allProducts = []; // مسح القوائم في حالة الخطأ
          _displayProducts = [];
        });
      }
    } finally {
      // إخفاء مؤشر التحميل دائماً في النهاية
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // تطبيق الفلاتر (بحث، نوع المحصول) والترتيب على قائمة المنتجات
  void _applyFiltersAndSort() {
    if (!mounted) return;

    List<ProductWithImages> result = List.from(_allProducts); // نسخة قابلة للتعديل

    // 1. تطبيق فلتر البحث
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where((pwi) => pwi.product.title.toLowerCase().contains(query))
          .toList();
    }

    // 2. تطبيق فلتر نوع المحصول
    if (_currentFilterType == FilterType.filterByCrop &&
        _selectedCropIdForFilter != null) {
      result = result
          .where((pwi) => pwi.product.cropId == _selectedCropIdForFilter)
          .toList();
    }

    // 3. تطبيق الترتيب
    switch (_currentFilterType) {
      case FilterType.sortByDateNewestFirst:
        result.sort(
            (a, b) => (b.product.dateAdded).compareTo(a.product.dateAdded));
        break;
      case FilterType.sortByDateOldestFirst:
        result.sort(
            (a, b) => (a.product.dateAdded).compareTo(b.product.dateAdded));
        break;
      default: // الترتيب الافتراضي (الأحدث أولاً)
        result.sort(
            (a, b) => (b.product.dateAdded).compareTo(a.product.dateAdded));
        break;
    }

    // تحديث حالة الواجهة لعرض المنتجات المفلترة والمرتبة
    setState(() => _displayProducts = result);
  }

  // --- معالجات الأحداث (Event Handlers) ---

  // عند تغيير نص البحث
  void _onSearchChanged(String query) {
    if (_searchQuery != query) { // تجنب التحديث غير الضروري
      setState(() => _searchQuery = query);
      _applyFiltersAndSort(); // إعادة تطبيق الفلاتر
    }
  }

  // عند تغيير نوع الفلتر/الترتيب
  void _onFilterTypeChanged(FilterType? filterType) {
    final newFilter = filterType ?? FilterType.none;
    if (newFilter != _currentFilterType) { // تجنب التحديث غير الضروري
      setState(() {
        _currentFilterType = newFilter;
         // إذا لم يكن الفلتر حسب المحصول، قم بإلغاء تحديد المحصول
        if (_currentFilterType != FilterType.filterByCrop) {
           _selectedCropIdForFilter = null;
        }
        _applyFiltersAndSort(); // إعادة تطبيق الفلاتر
      });
    }
  }

  // عند اختيار محصول من القائمة المنسدلة (فقط عندما يكون الفلتر حسب المحصول نشطاً)
  void _onCropSelectedForFilter(int? cropId) {
    if (_currentFilterType == FilterType.filterByCrop) {
      setState(() {
        _selectedCropIdForFilter = cropId;
        _applyFiltersAndSort(); // إعادة تطبيق الفلاتر
      });
    }
  }

  // --- عمليات التنقل (Navigation) ---

  // الانتقال لصفحة إضافة/تعديل المنتج
  Future<void> _navigateManageProduct({Product? product}) async {
    if (!widget.isUserView) return; // فقط للمستخدم صاحب المنتجات

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ManageProductPage(product: product),
      ),
    );
    // إذا عاد بنتيجة true (تم الحفظ بنجاح)، أعد تحميل البيانات لعرض التغييرات
    if (result == true && mounted) {
      _loadInitialData(showLoading: false); // إعادة تحميل بدون إظهار مؤشر التحميل الرئيسي
    }
  }

  // الانتقال لصفحة تفاصيل المنتج
  void navigateToDetail(ProductWithImages productWithImages) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(productWithImages: productWithImages),
      ),
    );
  }

  // --- عمليات المنتج (Product Actions) ---

  // معالجة حذف المنتج
  Future<void> _handleDeleteProduct(Product product) async {
    if (!widget.isUserView || product.productId == null) return; // التحقق من الصلاحية

    try {
      final result = await _deleteProduct(product.productId!);
      if (!mounted) return; // التحقق بعد العملية غير المتزامنة

      result.fold(
        (failure) {
          // عرض رسالة خطأ في حالة فشل الحذف
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(failure.getLocalizedMessage(context)),
            backgroundColor: AppConstants.errorColor,
          ));
        },
        (_) {
          setState(() {
            _allProducts.removeWhere((pwi) => pwi.product.productId == product.productId);
            // لا حاجة لـ _applyFiltersAndSort() هنا لأن displayProducts ستُبنى من allProducts المحدثة
             _applyFiltersAndSort(); // تحديث القائمة المعروضة
          });
          // 2. عرض رسالة نجاح
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.productDeletedSuccessfully),
            backgroundColor: AppConstants.successColor,
          ));
        },
      );
    } catch (e) {
      // معالجة الأخطاء غير المتوقعة
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.unexpectedError(e.toString())),
          backgroundColor: AppConstants.errorColor,
        ));
      }
    }
  }

  // --- بناء الواجهة (Build Method) ---
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      // AppBar يظهر فقط في حالة عرض منتجات المستخدم
      appBar: widget.isUserView
          ? CustomAppBar(
              title: localizations.myProducts,
              iconTheme: const IconThemeData(color: AppConstants.textOnPrimary),
              backgroundColor: AppConstants.primaryColorDark,
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => _loadInitialData(showLoading: false), // السحب للتحديث
        color: AppConstants.primaryColor,
        backgroundColor: AppConstants.backgroundColor,
        child: Column(
          children: [
            // --- شريط البحث والفلتر (Widget مفصول) ---
            ProductListHeader(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              currentFilter: _currentFilterType,
              onFilterChanged: _onFilterTypeChanged,
              isLoading: _isLoading,
              localizations: localizations,
            ),

            // --- قسم فلتر المحاصيل (Widget مفصول) ---
            CropFilterSection(
              currentFilterType: _currentFilterType,
              isLoading: _isLoading,
              selectedCropId: _selectedCropIdForFilter,
              onCropSelected: _onCropSelectedForFilter,
              localizations: localizations,
            ),

            // --- محتوى القائمة الرئيسي (Widget مفصول) ---
            Expanded(
              child: ProductListContent(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                displayProducts: _displayProducts,
                searchQuery: _searchQuery,
                currentFilterType: _currentFilterType,
                selectedCropIdForFilter: _selectedCropIdForFilter,
                isUserView: widget.isUserView,
                onRetry: _loadInitialData,
                onProductTap: navigateToDetail,
                onEditTap: (product) => _navigateManageProduct(product: product),
                onDeleteTap: _handleDeleteProduct,
                localizations: localizations,
              ),
            ),
          ],
        ),
      ),
      // زر الإضافة يظهر فقط في حالة عرض منتجات المستخدم
      floatingActionButton: widget.isUserView
          ? FloatingActionButton(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: AppConstants.whiteColor,
              tooltip: localizations.addProduct,
              // تعطيل الزر أثناء التحميل
              onPressed: _isLoading ? null : () => _navigateManageProduct(),
              child: const Icon(AppConstants.addIcon),
            )
          : null,
    );
  }
}