// lib/features/core/presentation/pages/main_page.dart

import 'package:farmersfriendapp/prof.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/user_management_page.dart';
import 'package:farmersfriendapp/features/diagnosis/presentation/screens/diagnosis_screen.dart';
import 'package:farmersfriendapp/features/guideline/presentation/pages/guideline_list_page.dart';
import 'package:farmersfriendapp/features/product/presentation/pages/product_list_page.dart';
import 'package:farmersfriendapp/features/weather/presentation/pages/weather_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  int? _userId;
  int? _accountType;

  // قوائم مُهيَّأة افتراضيًا لتجنّب LateInitializationError
  List<Widget> _pages = [];
  List<BottomNavigationBarItem> _navigationItems = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authLocal = sl.authLocalDataSource;
    final userId = await authLocal.getUserId();

    if (userId != null) {
      final user = await authLocal.getUser(userId);
      _accountType = user.accountType;
      _userId = user.id;
    }

    setState(() {
      _isLoading = false;
      // نترك التهيئة النهائية لـ build بناء على _isLoading
    });
  }

  /// يهيئ الصفحات وعناصر التنقل عند أول بناء بعد تحميل البيانات
  void _maybeSetupNavigation(AppLocalizations loc) {
    if (_navigationItems.isEmpty && !_isLoading) {
      _pages = _buildPagesByAccountType();
      _navigationItems = _buildNavItemsByAccountType(loc);
      // نتأكد أن selectedIndex ضمن النطاق الصحيح
      if (_selectedIndex >= _pages.length) {
        _selectedIndex = 0;
      }
    }
  }

  List<Widget> _buildPagesByAccountType() {
    switch (_accountType) {
      case AppConstants.accountTypeAdmin:
        return [
          const ProductListPage(userId: 0),
          const WeatherPage(),
          const GuidelineListPage(userId: 0),
          DiagnosisScreen(),
          const ProfileScreen(),
        ];
      case AppConstants.accountTypeFarmer:
        return [
          ProductListPage(userId: _userId!),
          const WeatherPage(),
          const GuidelineListPage(userId: 0),
          DiagnosisScreen(),
        ];
      case AppConstants.accountTypeAgriculturalGuide:
        return [
          GuidelineListPage(userId: _userId!),
          const WeatherPage(),
          DiagnosisScreen(),
        ];
      default:
        // ضيف هنا صفحات افتراضية إذا لم يُعرف نوع الحساب
        return [
          const ProductListPage(userId: 0),
          const WeatherPage(),
          const GuidelineListPage(userId: 0),
          DiagnosisScreen(),
        ];
    }
  }

  List<BottomNavigationBarItem> _buildNavItemsByAccountType(
      AppLocalizations loc) {
    switch (_accountType) {
      case AppConstants.accountTypeAdmin:
        return [
          _navItem(Icons.shopping_basket_outlined, loc.products),
          _navItem(Icons.wb_sunny_outlined, loc.weather),
          _navItem(Icons.lightbulb_outline, loc.guidelines),
          _navItem(Icons.healing_outlined, loc.plantDiagnosis),
          _navItem(Icons.supervisor_account, loc.manageUsers),
        ];
      case AppConstants.accountTypeFarmer:
        return [
          _navItem(Icons.shopping_basket_outlined, loc.products),
          _navItem(Icons.wb_sunny_outlined, loc.weather),
          _navItem(Icons.lightbulb_outline, loc.guidelines),
          _navItem(Icons.healing_outlined, loc.plantDiagnosis),
        ];
      case AppConstants.accountTypeAgriculturalGuide:
        return [
          _navItem(Icons.lightbulb_outline, loc.guidelines),
          _navItem(Icons.wb_sunny_outlined, loc.weather),
          _navItem(Icons.healing_outlined, loc.plantDiagnosis),
        ];
      default:
        return [
          _navItem(Icons.shopping_basket_outlined, loc.products),
          _navItem(Icons.wb_sunny_outlined, loc.weather),
          _navItem(Icons.lightbulb_outline, loc.guidelines),
          _navItem(Icons.healing_outlined, loc.plantDiagnosis),
        ];
    }
  }

  BottomNavigationBarItem _navItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  String _appBarTitle(AppLocalizations loc) {
    if (_navigationItems.isEmpty) return loc.appTitle;
    return _navigationItems[_selectedIndex].label ?? loc.appTitle;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // نهيئ التنقل عند أول build بعد انتهاء التحميل
    _maybeSetupNavigation(loc);

    return Scaffold(
      appBar: CustomAppBar(title: _appBarTitle(loc)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      bottomNavigationBar: _isLoading
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
              items: _navigationItems,
              type: BottomNavigationBarType.fixed,
              backgroundColor: theme.colorScheme.surface,
              selectedItemColor: AppConstants.primaryColorDark,
              unselectedItemColor: AppConstants.greyColor,
            ),
    );
  }
}
