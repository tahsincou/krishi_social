import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_mvp_starter/features/auth/data/dto/login_request.dart';

import 'auth_provider.dart';
import 'auth_state.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(const AuthState());

  final Ref ref;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);

    try {
      await ref.read(loginUseCaseProvider)(
        LoginRequest(email: email, password: password),
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> checkLogin() async {
    state = state.copyWith(isLoading: true);

    final user = await ref.read(checkLoginUseCaseProvider)();

    if (user != null) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      );
      return true;
    }

    state = state.copyWith(isLoading: false, isAuthenticated: false);

    return false;
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider)();

    state = const AuthState();
  }
}
