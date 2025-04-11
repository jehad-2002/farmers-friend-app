enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final bool isObscured;

  const LoginState({
    required this.status,
    this.errorMessage,
    required this.isObscured,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? isObscured,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      isObscured: isObscured ?? this.isObscured,
    );
  }
}
