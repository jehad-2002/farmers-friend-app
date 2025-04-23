// import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
// import 'package:farmersfriendapp/core/utils/app_constants.dart';
// import 'package:flutter/material.dart';

// ThemeData appThemeLight = ThemeData.light().copyWith(
//   colorScheme: ColorScheme.light(
//     primary: AppConstants.primaryColor,
//     primaryContainer: AppConstants.primaryColorDark,
//     secondary: AppConstants.accentColor,
//     secondaryContainer: AppConstants.accentColor,
//     background: AppConstants.backgroundColor,
//     surface: AppConstants.cardBackgroundColor,
//     error: AppConstants.errorColor,
//     onPrimary: AppConstants.textOnPrimary,
//     onSecondary: AppConstants.textOnAccent,
//     onBackground: AppConstants.textColorPrimary,
//     onSurface: AppConstants.textColorPrimary,
//     onError: AppConstants.textOnPrimary,
//     brightness: Brightness.light,
//   ),
//   scaffoldBackgroundColor: AppConstants.backgroundColor,
//   appBarTheme: AppBarTheme(
//     backgroundColor: AppConstants.primaryColorDark,
//     titleTextStyle: AppStyles.appBarTitle(null),
//     iconTheme: const IconThemeData(color: AppConstants.textOnPrimary),
//     actionsIconTheme: const IconThemeData(color: AppConstants.textOnPrimary),
//     centerTitle: true,
//     elevation: AppConstants.elevationLow,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(AppConstants.borderRadiusMedium)),
//     ),
//   ),
//   textTheme: TextTheme(
//     displayLarge: AppStyles.productTitleLarge,
//     displayMedium: AppStyles.sectionHeader,
//     bodyLarge: AppStyles.descriptionBody,
//     bodyMedium: AppStyles.descriptionBody.copyWith(fontSize: 14),
//     bodySmall: AppStyles.dateStyle,
//     titleLarge: AppStyles.productTitleMedium,
//     titleMedium: AppStyles.priceMedium,
//     titleSmall: AppStyles.priceLarge,
//     labelLarge: AppStyles.buttonTextStyle,
//     labelMedium: AppStyles.inputLabel,
//     labelSmall: AppStyles.hintText,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: AppConstants.primaryColorDark,
//       foregroundColor: AppConstants.textOnPrimary,
//       textStyle: AppStyles.buttonTextStyle,
//       shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.circular(AppConstants.borderRadiusCircular)),
//       padding: const EdgeInsets.symmetric(
//           horizontal: AppConstants.defaultPadding * 1.5,
//           vertical: AppConstants.defaultPadding),
//       elevation: AppConstants.elevationLow,
//     ),
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: TextButton.styleFrom(
//       foregroundColor: AppConstants.primaryColor,
//       textStyle:
//           AppStyles.buttonTextStyle.copyWith(fontWeight: FontWeight.w600),
//       padding: const EdgeInsets.symmetric(
//           horizontal: AppConstants.defaultPadding,
//           vertical: AppConstants.defaultPadding / 2),
//     ),
//   ),
//   outlinedButtonTheme: OutlinedButtonThemeData(
//     style: OutlinedButton.styleFrom(
//       foregroundColor: AppConstants.primaryColorDark,
//       textStyle:
//           AppStyles.buttonTextStyle.copyWith(fontWeight: FontWeight.w500),
//       shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.circular(AppConstants.borderRadiusCircular)),
//       side: BorderSide(color: AppConstants.primaryColorDark, width: 1.5),
//       padding: const EdgeInsets.symmetric(
//           horizontal: AppConstants.defaultPadding * 1.5,
//           vertical: AppConstants.defaultPadding),
//     ),
//   ),
//   cardTheme: CardTheme(
//     elevation: AppConstants.elevationLow,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
//     color: AppConstants.cardBackgroundColor,
//     margin: const EdgeInsets.symmetric(
//         horizontal: AppConstants.defaultMargin,
//         vertical: AppConstants.smallMargin),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     labelStyle: AppStyles.inputLabel,
//     hintStyle: AppStyles.hintText,
//     floatingLabelStyle:
//         AppStyles.inputLabel.copyWith(color: AppConstants.primaryColorDark),
//     errorStyle: AppStyles.errorText,
//     contentPadding: const EdgeInsets.symmetric(
//         vertical: AppConstants.defaultPadding * 0.7,
//         horizontal: AppConstants.defaultPadding),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//       borderSide: BorderSide(color: AppConstants.greyColor.withOpacity(0.5)),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//       borderSide: BorderSide(color: AppConstants.greyColor.withOpacity(0.5)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//       borderSide: BorderSide(color: AppConstants.primaryColorDark, width: 1.5),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//       borderSide: BorderSide(color: AppConstants.errorColor, width: 1.3),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
//       borderSide: BorderSide(color: AppConstants.errorColor, width: 1.5),
//     ),
//     filled: true,
//     fillColor: AppConstants.cardBackgroundColor.withOpacity(0.7),
//   ),
//   dialogTheme: DialogTheme(
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
//     backgroundColor: AppConstants.cardBackgroundColor,
//     titleTextStyle: AppStyles.sectionHeader,
//     contentTextStyle: AppStyles.descriptionBody,
//     elevation: AppConstants.elevationMedium,
//   ),
//   bottomSheetTheme: const BottomSheetThemeData(
//     backgroundColor: AppConstants.cardBackgroundColor,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//             top: Radius.circular(AppConstants.borderRadiusLarge))),
//   ),
// );
