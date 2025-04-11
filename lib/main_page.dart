import 'package:farmersfriendapp/core/presentation/widgets/custom_widgets.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/user_utils.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/user_management_page.dart';
import 'package:farmersfriendapp/features/diagnosis/presentation/screens/diagnosis_screen.dart';
import 'package:farmersfriendapp/features/guideline/presentation/pages/guideline_list_page.dart';
import 'package:farmersfriendapp/features/product/presentation/pages/product_list_page.dart';
import 'package:farmersfriendapp/features/weather/presentation/pages/weather_page.dart';
import 'package:farmersfriendapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/user_profile_avatar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String? userName;
  String? userImage;
  int? _userId;
  bool _isLoading = true;
  int? accountType;
  final List<Widget> _pages = [
    const ProductListPage(userId: 0),
    const WeatherPage(),
    const GuidelineListPage(userId: 0),
    DiagnosisScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authLocalDataSource = sl.authLocalDataSource;
    final userId = await authLocalDataSource.getUserId();

    if (userId != null) {
      final user = await authLocalDataSource.getUser(userId);
      accountType = user.accountType;
      _userId = user.id;
      setState(() {
        userName = user.name;
        userImage = user.profileImage;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final List<BottomNavigationBarItem> navigationItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.shopping_basket_outlined),
        label: localizations.products,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.wb_sunny_outlined),
        label: localizations.weather,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.lightbulb_outline),
        label: localizations.guidelines,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.lightbulb_outline),
        label: localizations.plantDiagnosis,
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: _getAppBarTitle(localizations),
      ),
      drawer: _isLoading ? null : _buildDrawer(context, localizations),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
        items: navigationItems,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildCurrentPage() {
    return _pages[_selectedIndex];
  }

  String _getAppBarTitle(AppLocalizations localizations) {
    switch (_selectedIndex) {
      case 0:
        return localizations.products;
      case 1:
        return localizations.weather;
      case 2:
        return localizations.guidelines;
      case 3:
        return localizations.plantDiagnosis;
      default:
        return localizations.appTitle;
    }
  }

  Widget _buildDrawer(BuildContext context, AppLocalizations localizations) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              image: const DecorationImage(
                image: AssetImage("assets/images/logo.webp"),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
            currentAccountPicture: UserProfileAvatar(
              imagePath: userImage,
              radius: 32,
              badge: accountType != null
                  ? buildUserTypeBadge(context, accountType!)
                  : null,
              isNetworkImage:
                  userImage != null && userImage!.startsWith('http'),
            ),
            accountName: Text(
              userName ?? localizations.guestUser,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            accountEmail: Text(
              UserUtils.getAccountTypeName(accountType!, localizations),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined,
                      size: 28.0, color: AppConstants.brownColor),
                  title: Text(localizations.userProfile,
                      style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language,
                      size: 28.0, color: AppConstants.brownColor),
                  title: Text(localizations.changeLanguage,
                      style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => LanguageSelectionDialog(
                        onLocaleSelected: (Locale newLocale) {
                          changeLanguage(context, newLocale);
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined,
                      size: 28.0, color: AppConstants.brownColor),
                  title: Text('change Theme',
                      style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () {
                    Navigator.pop(context);
                    toggleTheme(context);
                  },
                ),
                const Divider(),
                if (accountType == AppConstants.accountTypeAdmin) ...[
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined,
                        size: 28.0, color: AppConstants.brownColor),
                    title: Text(localizations.manageCategories,
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/categories');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings,
                        size: 28.0, color: AppConstants.brownColor),
                    title: Text(localizations.manageCrops,
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/crops');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings,
                        size: 28.0, color: AppConstants.brownColor),
                    title: Text(localizations.manageUsers,
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserManagementPage(),
                        ),
                      );
                    },
                  ),
                ] else if (accountType == AppConstants.accountTypeFarmer) ...[
                  ListTile(
                    leading: const Icon(Icons.agriculture_outlined,
                        size: 28.0, color: AppConstants.brownColor),
                    title: Text(localizations.products,
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductListPage(userId: _userId!),
                        ),
                      );
                    },
                  ),
                ] else if (accountType ==
                    AppConstants.accountTypeAgriculturalGuide) ...[
                  ListTile(
                    leading: const Icon(Icons.lightbulb_outlined,
                        size: 28.0, color: AppConstants.brownColor),
                    title: Text(localizations.guidelineTitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GuidelineListPage(userId: _userId!),
                        ),
                      );
                    },
                  ),
                ],
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app,
                      size: 28.0, color: AppConstants.brownColor),
                  title: Text(localizations.logout,
                      style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () async {
                    final authLocalDataSource = sl.authLocalDataSource;
                    try {
                      await authLocalDataSource.clearUserData();
                      Navigator.pushReplacementNamed(context, '/login');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("فشل في تسجيل الخروج: $e"),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
