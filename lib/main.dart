import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(AppConstants.prefsLocaleKey);
    final savedThemeMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _locale = savedLocale != null ? Locale(savedLocale) : null;
      _isDarkMode = savedThemeMode;
    });
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _saveLocale(locale);
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsLocaleKey, locale.languageCode);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _saveThemePreference();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'صديق المزارعين',
      theme: AppConstants.lightTheme, // Apply light theme
      darkTheme: AppConstants.darkTheme, // Apply dark theme
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Toggle between themes
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

void changeLanguage(BuildContext context, Locale newLocale) {
  final appState = context.findAncestorStateOfType<_MyAppState>();
  if (appState != null) {
    appState._setLocale(newLocale);
  }
}

void toggleTheme(BuildContext context) {
  final appState = context.findAncestorStateOfType<_MyAppState>();
  if (appState != null) {
    appState._toggleTheme();
  }
}
