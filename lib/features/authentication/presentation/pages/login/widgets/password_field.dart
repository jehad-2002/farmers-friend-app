import 'package:farmersfriendapp/core/utils/validators/input_validator.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_cubit.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  const PasswordField({super.key, required this.controller, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return AppTextField(
          controller: controller,
          label: localizations.password,
          icon: Icons.lock_outline,
          obscureText: state.isObscured,
          textInputAction: TextInputAction.done,
          enabled: state.status != LoginStatus.loading,
          onFieldSubmitted: (_) {
            if (state.status != LoginStatus.loading && formKey.currentState!.validate()) {
              context.read<LoginCubit>().login(
                    controller.text,
                    controller.text,
                  );
            }
          },
          validator: (value) => InputValidator.validatePassword(
            localizations: localizations,
            value: value,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              state.isObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: theme.iconTheme.color?.withOpacity(0.6),
            ),
            onPressed: state.status == LoginStatus.loading
                ? null
                : () => context.read<LoginCubit>().toggleObscure(),
          ),
        );
      },
    );
  }
}
