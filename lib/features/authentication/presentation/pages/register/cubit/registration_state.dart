import 'dart:io';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;
  final bool obscurePassword;
  final DateTime? selectedDate;
  final File? imageFile;
  final int? selectedAccountType;

  const RegisterState({
    required this.status,
    this.errorMessage,
    required this.obscurePassword,
    this.selectedDate,
    this.imageFile,
    this.selectedAccountType,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    bool? obscurePassword,
    DateTime? selectedDate,
    File? imageFile,
    int? selectedAccountType,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      selectedDate: selectedDate ?? this.selectedDate,
      imageFile: imageFile ?? this.imageFile,
      selectedAccountType: selectedAccountType ?? this.selectedAccountType,
    );
  }

  factory RegisterState.initial() {
    return const RegisterState(
      status: RegisterStatus.initial,
      obscurePassword: true,
      selectedDate: null,
      imageFile: null,
      selectedAccountType: null,
    );
  }
}
