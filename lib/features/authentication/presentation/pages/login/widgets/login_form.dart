import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/widgets/password_field.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/widgets/username_field.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/register/register_page.dart';
import 'package:farmersfriendapp/features/authentication/presentation/widgets/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_message.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_cubit.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.largePadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(title:  localizations.login),
                const SizedBox(height: AppConstants.mediumPadding),
                UsernameField(controller: _usernameController),
                const SizedBox(height: 16),
                PasswordField(controller: _passwordController, formKey: _formKey),
                const SizedBox(height: 24),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        if (state.errorMessage != null) ...[
                          ErrorMessage(message: state.errorMessage!),
                          const SizedBox(height: 8),
                        ],
                        AppButton(
                          text: localizations.login,
                          isLoading: state.status == LoginStatus.loading,
                          enabled: state.status != LoginStatus.loading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginCubit>().login(
                                    _usernameController.text,
                                    _passwordController.text,
                                  );

                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                TextButton(
                  onPressed: () => _navigateToRegister(context),
                  child: Text(localizations.dontHaveAccount, 
                  style: TextStyle(
                            color: theme.hintColor,
                            fontFamily: AppConstants.defaultFontFamily,
                    // style: AppStyles.productTitleLarge(context)
                      //      style: theme.textTheme.bodyMedium?.copyWith(
                      // color: theme.colorScheme.primary,
                      // fontFamily: theme.textTheme.bodyMedium?.fontFamily,)
                          ),
                          // ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
