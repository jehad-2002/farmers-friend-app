// lib/core/presentation/theme/app_gradients.dart
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

/// يوفر تدرجات لونية (Gradients) معرفة مسبقًا لاستخدامها في التطبيق.
class AppGradients {
  /// تدرج لخلفيات الصفحات أو الحاويات الكبيرة.
  static LinearGradient pageBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppConstants.backgroundColor.withOpacity(0.7),
      AppConstants.secondaryColor.withOpacity(0.9),
    ],
    stops: const [0.1, 0.9],
  );

  /// تدرج للأزرار الأساسية.
  static LinearGradient primaryButton = LinearGradient(
    colors: [
      AppConstants.primaryColor,
      AppConstants.primaryColorDark,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient subtleShadow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.black.withOpacity(0.05),
      Colors.black.withOpacity(0.0),
    ],
  );
}
