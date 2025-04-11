import 'package:farmersfriendapp/features/authentication/presentation/pages/register/cubit/registration_cubit.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/register/widgets/registration_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (_) => RegisterCubit(context),
      child: Scaffold(
        body: const RegistrationForm(),
      ),
    );
  }
}
