import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:krishi_social/features/auth/data/dto/login_request.dart';
import 'package:krishi_social/features/auth/data/dto/register_request.dart';

import 'auth_provider.dart';
import 'auth_state.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(const AuthState());

  final Ref ref;

  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await ref.read(registerUseCaseProvider)(request);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: error.toString(),
      );

      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await ref.read(loginUseCaseProvider)(
        LoginRequest(email: email, password: password),
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );

      debugPrint(
        'Authenticated user: '
        '${state.user?.id}, '
        '${state.user?.name}, '
        '${state.user?.phone}',
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: error.toString(),
      );

      return false;
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

    state = state.copyWith(
      isAuthenticated: false,
      clearUser: true,
      clearError: true,
    );
  }
}
