// lib/core/utils/validators/input_validator.dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputValidator {
  static String? _validateRequired(AppLocalizations localizations,
      String? value, String Function() emptyErrorMessageProvider) {
    if (value == null || value.trim().isEmpty) {
      return emptyErrorMessageProvider();
    }
    return null;
  }

  static String? validateName(
      {required AppLocalizations localizations, required String? value}) {
    final requiredError = _validateRequired(
        localizations, value, () => localizations.pleaseEnterName);
    if (requiredError != null) return requiredError;

    if (value!.trim().length < 2) {
      return localizations.nameTooShort;
    }
    return null;
  }

  static String? validateUsername(
      {required AppLocalizations localizations, required String? value}) {
    final requiredError = _validateRequired(
        localizations, value, () => localizations.pleaseEnterUsername);
    if (requiredError != null) return requiredError;

    if (value!.trim().length < 4) {
      return localizations.usernameTooShort;
    }
    return null;
  }

  static String? validatePassword(
      {required AppLocalizations localizations, required String? value}) {
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterPassword;
    }

    if (value.length < 6) {
      return localizations.passwordTooShort;
    }
    return null;
  }

  static String? validatePhoneNumber(
      {required AppLocalizations localizations, required String? value}) {
    final requiredError = _validateRequired(
        localizations, value, () => localizations.pleaseEnterPhoneNumber);
    if (requiredError != null) return requiredError;

    final phoneRegExp = RegExp(r'^\+?[0-9]{9,15}$');

    if (!phoneRegExp.hasMatch(value!.trim())) {
      return localizations.invalidPhoneNumber;
    }
    return null;
  }

  static String? validatePrice(
      {required AppLocalizations localizations, required String? value}) {
    final requiredError = _validateRequired(
        localizations, value, () => localizations.pleaseEnterPrice);
    if (requiredError != null) return requiredError;

    final double? price = double.tryParse(value!);
    if (price == null) {
      return localizations.invalidPriceFormat;
    }
    if (price <= 0) {
      return localizations.priceMustBePositive;
    }
    return null;
  }

  static String? validateGenericRequiredField(
      {required AppLocalizations localizations,
      required String? value,
      required String Function() emptyErrorMessageProvider}) {
    return _validateRequired(localizations, value, emptyErrorMessageProvider);
  }

  static String? validateNonNegativeInteger(
      {required AppLocalizations localizations,
      required String? value,
      required String Function() fieldNameProvider,
      required String Function() requiredErrorMessageProvider,
      required String Function(String fieldName)
          invalidFormatErrorMessageProvider,
      required String Function(String fieldName)
          mustBeNonNegativeErrorMessageProvider}) {
    final requiredError =
        _validateRequired(localizations, value, requiredErrorMessageProvider);
    if (requiredError != null) return requiredError;

    final int? intValue = int.tryParse(value!);
    final String fieldName = fieldNameProvider();

    if (intValue == null) {
      return invalidFormatErrorMessageProvider(fieldName);
    }
    if (intValue < 0) {
      return mustBeNonNegativeErrorMessageProvider(fieldName);
    }
    return null;
  }
}
