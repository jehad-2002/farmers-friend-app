import 'package:farmersfriendapp/features/authentication/presentation/pages/login/login_page.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/register/register_page.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/user_profile_page.dart';
import 'package:farmersfriendapp/features/category/presentation/pages/category_list_page.dart';
import 'package:farmersfriendapp/features/crop/presentation/pages/crop_list_page.dart';
import 'package:farmersfriendapp/features/guideline/presentation/pages/guideline_list_page.dart';
import 'package:farmersfriendapp/features/product/presentation/pages/product_list_page.dart';
import 'package:farmersfriendapp/main_page.dart';
import 'package:flutter/material.dart';
import 'package:farmersfriendapp/features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) =>  LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) =>  RegisterPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const UserProfilePage());
      case '/main':
        return MaterialPageRoute(builder: (_) => const MainPage());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoryListPage());
      case '/crops':
        return MaterialPageRoute(builder: (_) => const CropListPage());
      case '/guidelines':
        return MaterialPageRoute(
            builder: (_) => const GuidelineListPage(
                  userId: 0,
                ));
      case '/products':
        return MaterialPageRoute(
            builder: (_) => const ProductListPage(
                  userId: 0,
                ));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
