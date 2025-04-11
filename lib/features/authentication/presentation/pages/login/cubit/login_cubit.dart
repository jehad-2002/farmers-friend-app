import 'package:bloc/bloc.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/features/authentication/presentation/pages/login/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState(status: LoginStatus.initial, isObscured: true));

  Future<void> login(String username, String password) async {
    if (state.status == LoginStatus.loading) return;
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));
    
    final loginUser = sl.loginUser;
    try {
      final result = await loginUser(username.trim(), password.trim());
      result.fold(
        (failure) => emit(state.copyWith(status: LoginStatus.failure, errorMessage: failure.message)),
        (user) => emit(state.copyWith(status: LoginStatus.success))
      );
    } catch (e) {
      emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

  void toggleObscure() {
    emit(state.copyWith(isObscured: !state.isObscured));
  }
}
