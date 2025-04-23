import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle baseStyle = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    color: AppConstants.textColorPrimary,
    fontSize: 16,
  );

  static TextStyle appBarTitle(BuildContext? context) =>
      (context != null ? Theme.of(context).appBarTheme.titleTextStyle : null) ??
      baseStyle.copyWith(
        color: AppConstants.textOnPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 21,
      );

  static TextStyle sectionHeader = baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppConstants.primaryColorDark,
    height: 1.2,
  );

  static TextStyle productTitleLarge = baseStyle.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppConstants.primaryColorDark,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle productTitleMedium = baseStyle.copyWith(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: AppConstants.textColorPrimary,
    height: 1.3,
  );

  static TextStyle priceLarge = baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppConstants.primaryColor,
  );

  static TextStyle priceMedium = baseStyle.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppConstants.primaryColor,
  );

  static TextStyle dateStyle = baseStyle.copyWith(
    fontSize: 13,
    color: AppConstants.brownColor,
  );

  static TextStyle descriptionBody = baseStyle.copyWith(
    fontSize: 16,
    height: 1.6,
    color: AppConstants.textColorPrimary.withOpacity(0.85),
    letterSpacing: 0.2,
  );

  static TextStyle buttonTextStyle = baseStyle.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppConstants.successColor,
    letterSpacing: 0.5,
  );

  static TextStyle inputLabel = baseStyle.copyWith(
    color: AppConstants.textColorPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static TextStyle hintText = baseStyle.copyWith(
    color: AppConstants.greyColor,
    fontSize: 15,
    fontStyle: FontStyle.italic,
  );

  static TextStyle errorText = baseStyle.copyWith(
    color: AppConstants.errorColor,
    fontSize: 13,
  );
  static TextStyle userInfoLabel = baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppConstants.textColorSecondary,
  );

  static TextStyle userInfoValue = baseStyle.copyWith(
    fontSize: 16,
    color: AppConstants.textColorPrimary,
  );
}

