import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/get_user.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final authLocalDataSource = sl.authLocalDataSource;
    final authRepository =
        AuthRepositoryImpl(localDataSource: authLocalDataSource);
    final getUser = GetUser(authRepository);

    final userId = await authLocalDataSource.getUserId();

    if (userId != null) {
      final userResult = await getUser(userId);
      userResult.fold(
        (failure) {
          Navigator.of(context).pushReplacementNamed('/login');
        },
        (user) {
          Navigator.of(context).pushReplacementNamed('/main');
        },
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppConstants.logoPath, height: 150),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
