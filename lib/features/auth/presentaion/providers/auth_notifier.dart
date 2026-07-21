import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:krishi_social/features/auth/data/dto/login_request.dart';
import 'package:krishi_social/features/auth/data/dto/register_request.dart';
import 'package:krishi_social/features/auth/domain/entities/auth_status.dart';

import 'auth_provider.dart';
import 'auth_state.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(const AuthState());

  final Ref ref;

  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await ref.read(registerUseCaseProvider)(request);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        isLoading: false,
        user: user,
        clearError: true,
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        clearUser: true,
        error: error.toString(),
      );

      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await ref.read(loginUseCaseProvider)(
        LoginRequest(email: email, password: password),
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        isLoading: false,
        user: user,
        clearError: true,
      );

      debugPrint(
        'Authenticated user: '
        '${user.id}, ${user.name}, ${user.phone}',
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        clearUser: true,
        error: error.toString(),
      );

      return false;
    }
  }

  Future<bool> checkLogin() async {
    debugPrint('Starting auth restoration');

    state = state.copyWith(
      status: AuthStatus.restoring,
      isLoading: false,
      clearError: true,
    );

    try {
      final user = await ref.read(checkLoginUseCaseProvider)();

      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          isLoading: false,
          user: user,
          clearError: true,
        );

        debugPrint(
          'Restored user: '
          '${user.id}, ${user.name}, ${user.phone}',
        );

        return true;
      }

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        clearUser: true,
        clearError: true,
      );

      return false;
    } catch (error, stackTrace) {
      debugPrint('Session restoration failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        clearUser: true,
        error: error.toString(),
      );

      debugPrint('No saved authenticated user');

      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider)();

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      isLoading: false,
      clearUser: true,
      clearError: true,
    );
  }
}
