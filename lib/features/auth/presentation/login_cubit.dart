import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/auth_use_case.dart';
import 'login_state.dart';

/// Drives the login screen's state.
///
/// Calls [AuthUseCase], which delegates to the [AuthRepository] registered in
/// `di/app_module.dart`: [DemoAuthRepository] by default, or the real
/// repository when `useDemoLogin` is off.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._useCase) : super(const LoginInitial());

  final AuthUseCase _useCase;

  Future<void> login({required String email, required String password}) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      emit(const LoginFailure('Email and password are required.'));
      return;
    }

    emit(const LoginLoading());
    try {
      final user = await _useCase.login(email: trimmedEmail, password: password);
      emit(LoginSuccess(user));
    } on ArgumentError catch (error) {
      emit(LoginFailure('${error.message}'));
    }
  }

  /// Signs the current user out and resets to [LoginInitial].
  ///
  /// The GoRouter redirect in [AppRouter] sends the user back to the login
  /// route on the next navigation event.
  Future<void> logout() async {
    await _useCase.logout();
    emit(const LoginInitial());
  }

  /// Resets the state back to [LoginInitial], e.g. when the user dismisses
  /// an error banner and wants to retry.
  void reset() => emit(const LoginInitial());
}
