import 'dart:io';
import 'package:farmersfriendapp/core/models/product.dart';
// Ensure this model name is correct in your project
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/core/models/product_with_image.dart';
import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:farmersfriendapp/core/presentation/widgets/confirm_dialog.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Callbacks defined in product_grid.dart, ensure consistency
typedef ProductCallback = void Function(Product product);
typedef ProductWithImagesCallback = void Function(
    ProductWithImages productWithImages);

// ويدجت لعرض كارت منتج واحد
class CustomProductCard extends StatelessWidget {
  final ProductWithImages productWithImages;
  final bool showAdminActions; // عرض أزرار التحكم (تعديل/حذف)
  final ProductWithImagesCallback? onTap; // عند الضغط على الكارت
  final ProductCallback? onEditTap; // عند الضغط على زر التعديل
  // Renamed for clarity: this is called *after* confirmation
  final ProductCallback? onDeleteConfirm; // عند تأكيد الحذف من الـ Dialog

  const CustomProductCard({
    super.key,
    required this.productWithImages,
    required this.showAdminActions,
    this.onTap,
    this.onEditTap,
    this.onDeleteConfirm, // Updated parameter name
  });

  // تحديد مصدر الصورة (شبكة، ملف محلي، أو صورة افتراضية)
  ImageProvider _getImageProvider(List<ProductImage> images) { // Use ProductImage model
    if (images.isNotEmpty && images.first.imagePath.isNotEmpty) {
      final String imagePath = images.first.imagePath;
      // التحقق إذا كان الرابط من الشبكة
      if (imagePath.startsWith('http')) {
        return CachedNetworkImageProvider(imagePath);
      } else {
        // محاولة تحميل الصورة كملف محلي
        try {
          final file = File(imagePath);
          if (file.existsSync()) return FileImage(file);
        } catch (e) {
          // Log error if needed
          print("Error loading local product image file: $e");
        }
      }
    }
    // في حالة عدم وجود صورة أو حدوث خطأ، يتم عرض الصورة الافتراضية
    // Ensure AppConstants.defaultProductImagePath exists and is correct
    return const AssetImage(AppConstants.defaultImagePath); // Use a specific product default image
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final product = productWithImages.product;
    final imageProvider = _getImageProvider(productWithImages.images);

    return Card(
      elevation: AppConstants.elevationMedium,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
      clipBehavior: Clip.antiAlias, // لقص المحتوى الزائد عن الحواف الدائرية
      child: InkWell(
        onTap: onTap != null ? () => onTap!(productWithImages) : null,
        splashColor: theme.primaryColor.withOpacity(0.1), // لون عند الضغط
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // تمديد العناصر أفقياً
          children: [
            // --- قسم الصورة ---
            Expanded(
              flex: 3, // تأخذ 3 أجزاء من المساحة العمودية المتاحة
              child: Stack(
                fit: StackFit.expand, // لجعل الصورة تملأ المساحة المتاحة
                children: [
                  // عرض الصورة مع مؤشر تحميل للصور من الشبكة ومعالج الأخطاء
                  Image(
                    image: imageProvider,
                    fit: BoxFit.cover, // لتغطية المساحة المتاحة
                    // مؤشر تحميل يظهر فقط للصور من الشبكة
                    loadingBuilder: (context, child, loadingProgress) {
                       // Check if it's a network image and loading is in progress
                       if (imageProvider is CachedNetworkImageProvider && loadingProgress != null) {
                           return const Center(child: LoadingIndicator()); // Smaller indicator
                       }
                       // Otherwise, display the image (or placeholder)
                       return child;
                    },
                    // صورة تظهر في حالة فشل تحميل الصورة الأصلية
                    errorBuilder: (context, error, stackTrace) {
                      print("Error loading image for product ${product.title}: $error");
                      return Image.asset(
                         AppConstants.defaultImagePath, // Use a specific product default image
                         fit: BoxFit.cover,
                      );
                    },
                  ),
                  // --- أزرار التحكم (تظهر فقط إذا showAdminActions = true) ---
                  if (showAdminActions && (onEditTap != null || onDeleteConfirm != null))
                    Positioned(
                      bottom: AppConstants.smallPadding / 2,
                      right: AppConstants.smallPadding / 2,
                      child: Container(
                        // خلفية شبه شفافة للأزرار لتحسين القراءة
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.smallPadding * 0.75,
                            vertical: AppConstants.smallPadding / 3),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // لأخذ أقل مساحة ممكنة
                          children: [
                            // زر التعديل
                            if (onEditTap != null)
                              _buildAdminActionButton(
                                  context: context,
                                  icon: AppConstants.editIcon,
                                  tooltip: localizations.edit,
                                  color: AppConstants.whiteColor, // لون الأيقونة
                                  onPressed: () => onEditTap!(product)),
                            // فاصل بين الأزرار إذا كانا موجودين
                            if (onEditTap != null && onDeleteConfirm != null)
                              const SizedBox(width: AppConstants.smallPadding / 2),
                            // زر الحذف
                            if (onDeleteConfirm != null)
                              _buildAdminActionButton(
                                  context: context,
                                  icon: AppConstants.deleteIcon,
                                  tooltip: localizations.delete,
                                  color: AppConstants.errorColor, // لون مميز للحذف
                                  // عرض مربع حوار التأكيد قبل الحذف
                                  onPressed: () => _showDeleteConfirmation(context, localizations, product)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // --- قسم المعلومات (العنوان والسعر) ---
            Padding(
              padding: const EdgeInsets.all(AppConstants.smallPadding + 2), // زيادة الـ Padding قليلاً
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // محاذاة النصوص لليسار
                mainAxisAlignment: MainAxisAlignment.center, // توسيط عمودي بسيط
                children: [
                  // عنوان المنتج
                  Text(
                    product.title,
                    maxLines: 1, // سطر واحد فقط
                    overflow: TextOverflow.ellipsis, // إظهار ... للنص الطويل
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.defaultFontFamily, // استخدام الخط الافتراضي
                        height: 1.2), // تعديل ارتفاع السطر قليلاً
                  ),
                  const SizedBox(height: 3), // فاصل صغير
                  // سعر المنتج
                  Text(
                    // استخدام toStringAsFixed(0) لإزالة الكسور العشرية إذا كانت غير ضرورية
                    '${product.price.toStringAsFixed(0)} ${localizations.currency}',
                    style: AppStyles.priceMedium.copyWith(
                       fontSize: 14, // حجم خط مناسب للكارت
                       color: theme.primaryColor // استخدام اللون الأساسي للتطبيق
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت مساعد لبناء أزرار التحكم الصغيرة (تعديل/حذف)
  Widget _buildAdminActionButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      type: MaterialType.transparency, // لجعل IconButton شفافاً
      shape: const CircleBorder(), // شكل دائري
      clipBehavior: Clip.antiAlias, // لقص الـ ripple effect
      child: IconButton(
        icon: Icon(icon, size: 18), // حجم أيقونة أصغر
        color: color,
        padding: const EdgeInsets.all(6.0), // Padding داخلي أصغر
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32), // حجم زر أصغر
        splashRadius: 18, // نصف قطر دائرة الـ ripple effect
        tooltip: tooltip, // نص يظهر عند الوقوف على الزر
        onPressed: onPressed,
      ),
    );
  }

  // عرض مربع حوار لتأكيد الحذف
  void _showDeleteConfirmation(BuildContext context, AppLocalizations localizations, Product product) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: localizations.confirmDelete,
        content: localizations.deleteProductConfirmation(product.title), // رسالة تأكيد مخصصة باسم المنتج
        confirmText: localizations.delete,
        confirmTextColor: Theme.of(context).colorScheme.error, // لون مميز لزر الحذف
        onConfirm: () {
          // استدعاء الـ callback فقط عند التأكيد
          if (onDeleteConfirm != null) onDeleteConfirm!(product);
        },
      ),
    );
  }
}