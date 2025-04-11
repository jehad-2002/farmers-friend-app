import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/register_user.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/register/cubit/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUser registerUser;
final BuildContext context;

  RegisterCubit(this.context, {RegisterUser? registerUser})
      : registerUser = registerUser ?? sl.registerUser,
        super(RegisterState.initial());

  /// تبديل إخفاء/إظهار كلمة المرور
  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  /// تعيين تاريخ الميلاد
  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  /// تعيين الصورة المختارة
  void setImageFile(File file) {
    emit(state.copyWith(imageFile: file));
  }

  /// تعيين نوع الحساب
  void setAccountType(int? accountType) {
    emit(state.copyWith(selectedAccountType: accountType));
  }

  /// عملية التسجيل: استدعاء الـ UseCase الخاص بالتسجيل وإدارة الحالات
  Future<void> register({
    required String name,
    required String username,
    required String password,
    required String phoneNumber,
    required String address,
  }) async {
    if (state.selectedAccountType == null) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Please select account type',
      ));
      return;
    }
    emit(state.copyWith(status: RegisterStatus.loading, errorMessage: null));

    final newUser = User(
      id: null,
      name: name.trim(),
      username: username.trim(),
      password: password.trim(),
      phoneNumber: phoneNumber.trim(),
      address: address.trim(),
      dateOfBirth: state.selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(state.selectedDate!)
          : null,
      accountStatus: AppConstants.accountStatusActive,
      accountType: state.selectedAccountType!,
      profileImage: state.imageFile?.path,
      createdAt: AppConstants.getCurrentDateFormatted(),
      updatedAt: null,
    );

    try {
      final result = await registerUser(newUser);
      result.fold(
        (failure) {
          emit(state.copyWith(
            status: RegisterStatus.failure,
            errorMessage: failure.getLocalizedMessage(context),
          ));
        },
        (registeredUser) {
          emit(state.copyWith(status: RegisterStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: 'Unexpected error: ${e.toString()}'));
    }
  }
}
