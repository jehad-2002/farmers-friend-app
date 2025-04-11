// lib/core/presentation/theme/app_gradients.dart
import 'package:flutter/material.dart';

/// يوفر تدرجات لونية (Gradients) معرفة مسبقًا لاستخدامها في التطبيق.
class AppGradients {
  /// تدرج لخلفيات الصفحات أو الحاويات الكبيرة.
  static LinearGradient pageBackground(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.colorScheme.background.withOpacity(0.7),
        theme.colorScheme.surface.withOpacity(0.9),
      ],
      stops: const [0.1, 0.9],
    );
  }

  /// تدرج للأزرار الأساسية.
  static LinearGradient primaryButton(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.primaryContainer,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  static LinearGradient subtleShadow(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withOpacity(0.05),
        Colors.black.withOpacity(0.0),
      ],
    );
  }
}
