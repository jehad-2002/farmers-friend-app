// lib/core/utils/user_utils.dart
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserUtils {
  static String getAccountTypeName(
      int accountType, AppLocalizations localizations) {
    switch (accountType) {
      case AppConstants.accountTypeFarmer:
        return localizations.farmer;
      case AppConstants.accountTypeVisitor:
        return localizations.guestUser;
      case AppConstants.accountTypeAdmin:
        return localizations.admin;
      case AppConstants.accountTypeTrader:
        return localizations.trader;
      case AppConstants.accountTypeAgriculturalGuide:
        return localizations.agriculturalGuide;
      default:
        return localizations.unknown;
    }
  }

  static String getAccountStatusText(
      int status, AppLocalizations localizations) {
    return status == AppConstants.accountStatusActive
        ? localizations.active
        : localizations.inactive;
  }
}
