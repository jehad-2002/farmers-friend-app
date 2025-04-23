import 'package:farmersfriendapp/core/enums/filter_type.dart';
import 'package:farmersfriendapp/core/presentation/widgets/crop_selection_dropdown.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ويدجت لعرض قائمة اختيار المحصول للفلترة
class CropFilterSection extends StatelessWidget {
  final FilterType currentFilterType;
  final bool isLoading;
  final int? selectedCropId;
  final ValueChanged<int?> onCropSelected;
  final AppLocalizations localizations;

  const CropFilterSection({
    Key? key,
    required this.currentFilterType,
    required this.isLoading,
    required this.selectedCropId,
    required this.onCropSelected,
    required this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // عرض هذا القسم فقط إذا كان الفلتر حسب المحصول نشطاً والبيانات ليست قيد التحميل
    if (currentFilterType == FilterType.filterByCrop && !isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding / 2),
        child: CropSelectionDropdown(
          initialValue: selectedCropId,
          labelText: localizations.filterByCrop,
          enabled: !isLoading, // تعطيل أثناء التحميل (احتياطي)
          onChanged: onCropSelected,
          validator: null, // لا نحتاج للتحقق هنا
        ),
      );
    } else {
      // إرجاع ويدجت فارغ إذا لم يكن الفلتر نشطاً
      return const SizedBox.shrink();
    }
  }
}