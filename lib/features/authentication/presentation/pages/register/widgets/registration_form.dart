import 'dart:io';
import 'package:farmersfriendapp/features/authentication/presentation/pages/register/cubit/registration_cubit.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/register/cubit/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_text_field.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_message.dart';
import 'package:farmersfriendapp/core/presentation/widgets/user_profile_avatar.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/validators/input_validator.dart';
import 'package:farmersfriendapp/features/authentication/presentation/widgets/account_type_dropdown.dart';
import 'package:farmersfriendapp/features/authentication/presentation/widgets/auth_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.primaryColor,
              onPrimary: AppConstants.whiteColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      context.read<RegisterCubit>().setSelectedDate(picked);
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
      );
      if (pickedFile != null) {
        context.read<RegisterCubit>().setImageFile(File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.imagePickerError)),
      );
    }
  }

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().register(
            name: _nameController.text,
            username: _usernameController.text,
            password: _passwordController.text,
            phoneNumber: _phoneNumberController.text,
            address: _addressController.text,
          );
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: AppGradients.pageBackground),
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
                      AuthHeader(title: localizations.register),
                      const SizedBox(height: AppConstants.mediumPadding),
                      Center(
                        child: GestureDetector(
                          onTap: state.status == RegisterStatus.loading
                              ? null
                              : () => _pickImage(context),
                          child: UserProfileAvatar(
                            imagePath: state.imageFile?.path,
                            radius: 55,
                            placeholderAsset: AppConstants.defaultUserProfileImagePath,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.mediumPadding),
                      AppTextField(
                        controller: _nameController,
                        label: localizations.fullName,
                        icon: Icons.person_outline,
                        enabled: state.status != RegisterStatus.loading,
                        textInputAction: TextInputAction.next,
                        validator: (value) => InputValidator.validateName(
                          localizations: localizations,
                          value: value,
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      AppTextField(
                        controller: _usernameController,
                        label: localizations.username,
                        icon: Icons.alternate_email,
                        enabled: state.status != RegisterStatus.loading,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value) => InputValidator.validateUsername(
                          localizations: localizations,
                          value: value,
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      AppTextField(
                        controller: _passwordController,
                        label: localizations.password,
                        icon: Icons.lock_outline,
                        enabled: state.status != RegisterStatus.loading,
                        textInputAction: TextInputAction.next,
                        obscureText: state.obscurePassword,
                        validator: (value) => InputValidator.validatePassword(
                          localizations: localizations,
                          value: value,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: theme.iconTheme.color?.withOpacity(0.6),
                          ),
                          onPressed: state.status == RegisterStatus.loading
                              ? null
                              : () => context.read<RegisterCubit>().togglePasswordVisibility(),
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      AppTextField(
                        controller: _phoneNumberController,
                        label: localizations.phoneNumber,
                        icon: Icons.phone_outlined,
                        enabled: state.status != RegisterStatus.loading,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        validator: (value) => InputValidator.validatePhoneNumber(
                          localizations: localizations,
                          value: value,
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      AppTextField(
                        controller: _addressController,
                        label: localizations.address,
                        icon: Icons.location_on_outlined,
                        enabled: state.status != RegisterStatus.loading,
                        textInputAction: TextInputAction.next,
                        validator: (value) => InputValidator.validateGenericRequiredField(
                          localizations: localizations,
                          value: value,
                          emptyErrorMessageProvider: () => localizations.pleaseEnterAddress,
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      InkWell(
                        onTap: state.status == RegisterStatus.loading ? null : () => _selectDate(context),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusCircular),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: localizations.dateOfBirth,
                            labelStyle: TextStyle(
                              color: state.status == RegisterStatus.loading ? AppConstants.greyColor : theme.primaryColorDark,
                              fontFamily: AppConstants.defaultFontFamily,
                            ),
                            prefixIcon: Icon(
                              AppConstants.calendarTodayIcon,
                              color: state.status == RegisterStatus.loading ? AppConstants.greyColor : theme.primaryColorDark,
                              size: 22,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusCircular),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: state.status == RegisterStatus.loading
                                ? theme.disabledColor.withOpacity(0.1)
                                : AppConstants.cardBackgroundColor.withOpacity(0.8),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: AppConstants.defaultPadding * 0.9,
                              horizontal: AppConstants.defaultPadding,
                            ),
                          ),
                          child: Text(
                            state.selectedDate != null
                                ? DateFormat.yMd(localizations.localeName).format(state.selectedDate!)
                                : localizations.selectDateOfBirth,
                            style: TextStyle(
                              fontSize: 16,
                              color: state.status == RegisterStatus.loading
                                  ? AppConstants.greyColor
                                  : (state.selectedDate != null ? AppConstants.textColorPrimary : AppConstants.greyColor),
                              fontFamily: AppConstants.defaultFontFamily,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      AccountTypeDropdown(
                        initialValue: state.selectedAccountType,
                        onChanged:  (value) => context.read<RegisterCubit>().setAccountType(value),
                        enabled: state.status != RegisterStatus.loading,
                        validator: (value) => value == null ? localizations.pleaseSelectAccountType : null,
                      ),
                      const SizedBox(height: AppConstants.largePadding),
                      if (state.errorMessage != null)
                        ErrorMessage(message: state.errorMessage!),
                      if (state.errorMessage != null)
                        const SizedBox(height: AppConstants.smallPadding),
                      AppButton(
                        text: localizations.register,
                        onPressed: state.status == RegisterStatus.loading ? (){} : () => _register(context),
                        isLoading: state.status == RegisterStatus.loading,
                        enabled: state.status != RegisterStatus.loading,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      TextButton(
                        onPressed: state.status == RegisterStatus.loading ? null : () => _navigateToLogin(context),
                        child: Text(
                          localizations.alreadyHaveAccount,
                          style: TextStyle(
                            color: theme.primaryColorDark,
                            fontFamily: AppConstants.defaultFontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
