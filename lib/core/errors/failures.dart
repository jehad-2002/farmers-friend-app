import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  /// دالة لإرجاع الرسالة المترجمة، ويمكن إعادة تعريفها في الفئات الفرعية
  String getLocalizedMessage(BuildContext context) {
    return message; // القيمة الافتراضية
  }

  @override
  List<Object> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.databaseError(message);
    }
    return message;
  }
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.authenticationError(message);
    }
    return message;
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.cacheError(message);
    }
    return message;
  }
}

class ProductNotFoundFailure extends Failure {
  const ProductNotFoundFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.productNotFound(message);
    }
    return message;
  }
}

class CategoryNotFoundFailure extends Failure {
  const CategoryNotFoundFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.categoryNotFound(message);
    }
    return message;
  }
}

class CropNotFoundFailure extends Failure {
  const CropNotFoundFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.cropNotFound(message);
    }
    return message;
  }
}

class GuidelineNotFoundFailure extends Failure {
  const GuidelineNotFoundFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.guidelineNotFound(message);
    }
    return message;
  }
}

class ImageUploadFailure extends Failure {
  const ImageUploadFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.imageUploadError(message);
    }
    return message;
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      return localizations.networkError(message);
    }
    return message;
  }
}

class ImageProcessingFailure extends Failure {
  const ImageProcessingFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    try {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        return localizations.imageProcessingError(message);
      }
    } catch (e) {
      // يمكن تسجيل الخطأ إذا لزم الأمر
      print("Missing localization key: imageProcessingError");
    }
    return 'Image Error: $message';
  }
}

class ModelInferenceFailure extends Failure {
  const ModelInferenceFailure(super.message);
  @override
  String getLocalizedMessage(BuildContext context) {
    try {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        return localizations.modelInferenceError(message);
      }
    } catch (e) {
      print("Missing localization key: modelInferenceError");
    }
    return 'Model Error: $message';
  }
}
