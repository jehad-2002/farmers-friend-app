import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppConstants {
  static const String appversion = '1.0.0';
  static const String databaseName = 'agri_database.db';

  static const int accountStatusInactive = 0;
  static const int accountStatusActive = 1;

  static const int accountTypeFarmer = 1;
  static const int accountTypeVisitor = 2;
  static const int accountTypeAdmin = 3;
  static const int accountTypeTrader = 4;
  static const int accountTypeAgriculturalGuide = 5;

  static const String prefsUserIdKey = 'userId';
  static const String prefsLocaleKey = 'selectedLocale';

  static const Color primaryColor = Color(0xFF558B2F);
  static const Color primaryColorDark = Color(0xFF33691E);
  static const Color accentColor = leafGreenColor;
  static const Color secondaryColor = Color(0xFFFFF8E1);
  static const Color backgroundColor = Color(0xFFF0F4C3);
  static const Color cardBackgroundColor = Color(0xFFFFFFFF);
  static const Color brownColor = Color(0xFF795548);
  static const Color brownLightColor = Color(0xFFA1887F);
  static const Color greenLightColor = Color(0xFFDCEDC8);
  static const Color yellowPaleColor = Color(0xFFFFECB3);

  // New colors inspired by nature
  static const Color soilBrownColor = Color(0xFF6D4C41);
  static const Color skyBlueColor = leafGreenColor;
  static const Color leafGreenColor = Color(0xFF388E3C);
  static const Color sunsetOrangeColor = Color(0xFFFF7043);

  static const Color textColorPrimary = Color(0xFF212121);
  static const Color textColorSecondary = brownColor;
  static const Color textOnPrimary = Colors.white;
  static const Color textOnAccent = Colors.black87;

  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = leafGreenColor;

  static final Color greyColor = Colors.grey[500]!;
  static final Color disabledColor = Colors.grey[350]!;
  static final Color shimmerBaseColor = Colors.grey[200]!;
  static final Color shimmerHighlightColor = Colors.grey[50]!;
  static const Color appBarIconBackgroundColor = Color(0x44000000);
  static const Color iconColorDefault = brownColor;
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;

  static const String _baseImagePath = 'assets/images';
  static const String logoPath = '$_baseImagePath/logo.png';
  static const String defaultguidelineImagePath = '$_baseImagePath/logo.webp';
  static const String defaultCropImagePath = '$_baseImagePath/logo.webp';
  static const String defaultGuidelineImagePath = '$_baseImagePath/logo.webp';
  static const String defaultUserProfileImagePath = '$_baseImagePath/logo.webp';
  static const String bestModelPath = 'assets/images/plant_disease_model.tflite';
  static const String defaultImagePath = 'assets/images/placeholder.png';

  static const IconData appIcon = Icons.eco;
  static const IconData arrowBackIcon = Icons.arrow_back_ios_new;
  static const IconData infoOutlineIcon = Icons.info_outline;
  static const IconData shoppingCartCheckoutIcon = Icons.shopping_cart_checkout;
  static const IconData phoneIcon = Icons.phone_outlined;
  static const IconData personIcon = Icons.person_outline;
  static const IconData locationOnIcon = Icons.location_on_outlined;
  static const IconData errorOutlineIcon = Icons.error_outline;
  static const IconData searchIcon = Icons.search;
  static const IconData clearIcon = Icons.clear;
  static const IconData filterListIcon = Icons.filter_list;
  static const IconData starIcon = Icons.star;
  static const IconData starHalfIcon = Icons.star_half;
  static const IconData starBorderIcon = Icons.star_border;
  static const IconData addIcon = Icons.add_circle_outline;
  static const IconData editIcon = Icons.edit_outlined;
  static const IconData deleteIcon = Icons.delete_outline;
  static const IconData logoutIcon = Icons.logout;
  static const IconData saveIcon = Icons.save_alt_outlined;
  static const IconData categoryIcon = Icons.category_outlined;
  static const IconData cropIcon = Icons.agriculture_outlined;
  static const IconData productIcon = Icons.shopping_bag_outlined;
  static const IconData guidelineIcon = Icons.lightbulb_outline;
  static const IconData homeIcon = Icons.home_outlined;
  static const IconData accountCircleIcon = Icons.account_circle_outlined;
  static const IconData weatherIcon = Icons.wb_sunny_outlined;
  static const IconData languageIcon = Icons.language;
  static const IconData visibilityOnIcon = Icons.visibility_outlined;
  static const IconData visibilityOffIcon = Icons.visibility_off_outlined;
  static const IconData cakeIcon = Icons.cake_outlined;
  static const IconData verifiedUserIcon = Icons.verified_user_outlined;
  static const IconData dateRangeIcon = Icons.date_range_outlined;
  static const IconData updateIcon = Icons.update_outlined;
  static const IconData lockIcon = Icons.lock_outline;
  static const IconData calendarTodayIcon = Icons.calendar_today_outlined;
  static const IconData descriptionIcon = Icons.description_outlined;
  static const IconData addAPhotoIcon = Icons.add_a_photo_outlined;
  static const IconData closeIcon = Icons.close;
  static const IconData titleIcon = Icons.title;
  static const IconData textSnippetIcon = Icons.text_snippet_outlined;
  static const IconData attachMoneyIcon = Icons.attach_money;

  // Additional icons for agricultural context
  static const IconData tractorIcon = Icons.agriculture; // Requires custom icon package
  static const IconData plantIcon = Icons.local_florist;
  static const IconData fieldIcon = Icons.landscape;

  static const double smallPadding = 6.0;
  static const double defaultPadding = 12.0;
  static const double mediumPadding = 18.0;
  static const double largePadding = 24.0;

  // Enhanced paddings and margins for better spacing
  static const double extraLargePadding = 32.0;

  static const double smallMargin = 3.0;
  static const double defaultMargin = 6.0;
  static const double mediumMargin = 9.0;
  static const double largeMargin = 15.0;

  static const double extraLargeMargin = 20.0;

  static const double borderRadiusSmall = 6.0;
  static const double borderRadiusMedium = 10.0;
  static const double borderRadiusLarge = 14.0;
  static const double borderRadiusCircular = 30.0;

  // Additional border radius for more design options
  static const double borderRadiusExtraLarge = 20.0;

  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;

  static const String defaultDateFormat = 'yyyy-MM-dd';
  static const String defaultDateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  static String getCurrentDateFormatted({String format = defaultDateFormat}) {
    final now = DateTime.now();
    final formatter = DateFormat(format);
    return formatter.format(now);
  }

  static String getCurrentDateFormattedTime({String format = defaultDateTimeFormat}) {
    final now = DateTime.now();
    final formatter = DateFormat(format);
    return formatter.format(now);
  }

  static String formatDate(DateTime date, {String format = defaultDateFormat}) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }

  static String get defaultFontFamily => GoogleFonts.cairo().fontFamily!;

  // New font family for agricultural theme
  static String get agriculturalFontFamily => GoogleFonts.robotoSlab().fontFamily!;
  
  static const Duration shortAnimationDuration = Duration(milliseconds: 250);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration snackBarDuration = Duration(seconds: 3);

  // Adjusted animation durations for smoother transitions
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  static const Duration tooltipAnimationDuration = Duration(milliseconds: 300);

  // Grouped color constants for better organization
  static const Map<String, Color> colorPalette = {
    'primary': primaryColor,
    'primaryDark': primaryColorDark,
    'accent': leafGreenColor,
    'secondary': secondaryColor,
    'background': backgroundColor,
    'cardBackground': cardBackgroundColor,
    'textPrimary': textColorPrimary,
    'textSecondary': textColorSecondary,
    'error': errorColor,
    'success': successColor,
    'warning': warningColor,
    'info': leafGreenColor,
    'soilBrown': soilBrownColor,
    'skyBlue': backgroundColor,
    'leafGreen': leafGreenColor,
    'sunsetOrange': sunsetOrangeColor,
  };

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: leafGreenColor,
      surface: cardBackgroundColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardBackgroundColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textColorPrimary, fontFamily: defaultFontFamily),
      bodyMedium: TextStyle(color: textColorSecondary, fontFamily: defaultFontFamily),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: textOnPrimary),
      titleTextStyle: TextStyle(
        color: textOnPrimary,
        fontFamily: defaultFontFamily,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    colorScheme: ColorScheme.dark().copyWith(
      secondary: leafGreenColor,
      surface: Colors.grey[900],
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey[900],
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontFamily: defaultFontFamily),
      bodyMedium: TextStyle(color: greyColor, fontFamily: defaultFontFamily),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColorDark,
      iconTheme: IconThemeData(color: textOnPrimary),
      titleTextStyle: TextStyle(
        color: textOnPrimary,
        fontFamily: defaultFontFamily,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColorDark,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
}
