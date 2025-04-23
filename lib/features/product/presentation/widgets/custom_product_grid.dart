import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
// تأكد من أن المسار صحيح
import 'package:farmersfriendapp/features/product/presentation/widgets/custom_product_card.dart';
import 'package:flutter/material.dart';

// تعريف أنواع الـ Callbacks لتمريرها للـ Card
typedef ProductWithImagesCallback = void Function(
    ProductWithImages productWithImages);
typedef ProductCallback = void Function(Product product);

// ويدجت لعرض المنتجات في شكل شبكة
class CustomProductGrid extends StatelessWidget {
  final List<ProductWithImages> productsWithImages;
  final bool showAdminActions; // هل يجب إظهار أزرار التعديل والحذف؟
  final ProductWithImagesCallback? onProductTap; // عند الضغط على المنتج
  final ProductCallback? onEditTap; // عند الضغط على زر التعديل
  final ProductCallback? onDeleteTap; // عند تأكيد الحذف

  const CustomProductGrid({
    super.key,
    required this.productsWithImages,
    required this.showAdminActions,
    this.onProductTap,
    this.onEditTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام GridView.builder للأداء الأفضل مع القوائم الطويلة
    return GridView.builder(
      // إضافة Padding حول الشبكة
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding / 2,
          vertical: AppConstants.smallPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // عدد الأعمدة
        childAspectRatio: 0.75, // النسبة بين عرض وارتفاع كل عنصر
        crossAxisSpacing: AppConstants.defaultPadding / 2, // المسافة الأفقية
        mainAxisSpacing: AppConstants.defaultPadding / 2, // المسافة الرأسية
      ),
      itemCount: productsWithImages.length, // عدد العناصر في الشبكة
      itemBuilder: (context, index) {
        final productWithImagesItem = productsWithImages[index];
        // بناء كارت المنتج لكل عنصر في القائمة
        return CustomProductCard(
          // استخدام مفتاح لـ Flutter للتعرف على العناصر بشكل أفضل عند التغيير
          key: ValueKey(productWithImagesItem.product.productId ?? 'new_${index}'),
          productWithImages: productWithImagesItem,
          showAdminActions: showAdminActions,
          onTap: onProductTap,
          onEditTap: onEditTap,
          onDeleteConfirm: onDeleteTap, // تمرير دالة تأكيد الحذف
        );
      },
    );
  }
}