import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Use theme's scaffold background color
      body: Container(  decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                   theme.colorScheme.secondary.withOpacity(0.7),
                  theme.colorScheme.background,
                ],
              ),
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppConstants.logoPath, height: 150),
              const SizedBox(height: 30),
              LoadingIndicator(
                isCentered: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
