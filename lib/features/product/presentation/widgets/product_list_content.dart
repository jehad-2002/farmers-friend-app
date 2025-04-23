import 'package:farmersfriendapp/core/enums/filter_type.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/presentation/widgets/empty_list_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/product/presentation/widgets/custom_product_grid.dart'; // Import the grid
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ويدجت لعرض محتوى قائمة المنتجات (الشبكة، التحميل، الخطأ، فارغ)
class ProductListContent extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<ProductWithImages> displayProducts;
  final String searchQuery;
  final FilterType currentFilterType;
  final int? selectedCropIdForFilter;
  final bool isUserView;
  final VoidCallback onRetry;
  final ProductWithImagesCallback onProductTap;
  final ProductCallback onEditTap;
  final ProductCallback onDeleteTap;
  final AppLocalizations localizations;

  const ProductListContent({
    Key? key,
    required this.isLoading,
    required this.errorMessage,
    required this.displayProducts,
    required this.searchQuery,
    required this.currentFilterType,
    this.selectedCropIdForFilter,
    required this.isUserView,
    required this.onRetry,
    required this.onProductTap,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. عرض مؤشر التحميل
    if (isLoading) {
      return const LoadingIndicator(isCentered: true);
    }

    // 2. عرض رسالة الخطأ مع زر إعادة المحاولة
    if (errorMessage != null) {
      return ErrorIndicator(message: errorMessage!, onRetry: onRetry);
    }

    // 3. عرض مؤشر القائمة الفارغة
    if (displayProducts.isEmpty) {
      // تحديد الرسالة المناسبة بناءً على وجود فلتر أو كونها منتجات المستخدم
      final message = searchQuery.isNotEmpty ||
              (currentFilterType == FilterType.filterByCrop &&
                  selectedCropIdForFilter != null)
          ? localizations.noMatchingProductsFound // نتيجة البحث/الفلتر فارغة
          : (isUserView
              ? localizations.noOwnProductsFound // لا يوجد منتجات خاصة بالمستخدم
              : localizations.noProductsFound); // لا توجد منتجات بشكل عام
      return EmptyListIndicator(
          message: message, icon: AppConstants.productIcon);
    }

    // 4. عرض شبكة المنتجات
    return CustomProductGrid(
      productsWithImages: displayProducts,
      showAdminActions: isUserView, // إظهار أزرار التعديل/الحذف فقط للمستخدم
      onProductTap: onProductTap,
      onEditTap: onEditTap,
      onDeleteTap: onDeleteTap,
    );
  }
}