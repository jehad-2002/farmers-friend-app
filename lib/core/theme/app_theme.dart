// // 
//   // --- السمات ---
//   static final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: primaryColor,
//     colorScheme: ColorScheme.fromSwatch().copyWith(
//       secondary: accentColor,
//       error: errorColor,
//       background: backgroundColor,
//       surface: cardBackgroundColor,
//     ),
//     scaffoldBackgroundColor: backgroundColor,
//     cardColor: cardBackgroundColor,
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: textColorPrimary, fontFamily: defaultFontFamily),
//       bodyMedium: TextStyle(color: textColorSecondary, fontFamily: defaultFontFamily),
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: primaryColor,
//       iconTheme: IconThemeData(color: textOnPrimary),
//     ),
//     buttonTheme: ButtonThemeData(
//       buttonColor: primaryColor,
//       textTheme: ButtonTextTheme.primary,
//     ),
//   );

//   static final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: primaryColorDark,
//     colorScheme: ColorScheme.dark().copyWith(
//       secondary: accentColor,
//       error: errorColor,
//       background: darkBackgroundColor,
//       surface: darkCardColor,
//     ),
//     scaffoldBackgroundColor: darkBackgroundColor,
//     cardColor: darkCardColor,
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: Colors.white, fontFamily: defaultFontFamily),
//       bodyMedium: TextStyle(color: greyColor, fontFamily: defaultFontFamily),
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: primaryColorDark,
//       iconTheme: IconThemeData(color: textOnPrimary),
//     ),
//     buttonTheme: ButtonThemeData(
//       buttonColor: primaryColorDark,
//       textTheme: ButtonTextTheme.primary,
//     ),
//   );

//   static ThemeData getTheme(bool isDarkMode) {
//     return isDarkMode ? darkTheme : lightTheme;
//   }