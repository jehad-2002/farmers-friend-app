import 'package:farmersfriendapp/core/utils/validators/input_validator.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_cubit.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return AppTextField(
          controller: controller,
          label: localizations.username,
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          enabled: state.status != LoginStatus.loading,
          validator: (value) => InputValidator.validateUsername(
            localizations: localizations,
            value: value,
          ),
        );
      },
    );
  }
}
