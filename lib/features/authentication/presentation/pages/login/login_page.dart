import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_cubit.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_state.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.failure) {
              // يمكن عرض Snackbar أو أي طريقة أخرى للتنبيه عند الخطأ
            } else if (state.status == LoginStatus.success) {
              Navigator.pushReplacementNamed(context, '/main');
            }
          },
          child: Container(
            decoration: BoxDecoration(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: AppConstants.largePadding,
                ),
                child: const LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
