import 'package:krishi_social/features/auth/domain/entities/auth_status.dart';
import 'package:krishi_social/features/auth/domain/entities/user.dart';

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.user,
    this.error,
  });

  bool get isAuthenticated {
    return status == AuthStatus.authenticated && user != null;
  }

  bool get isRestoring {
    return status == AuthStatus.initial || status == AuthStatus.restoring;
  }

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    User? user,
    bool clearUser = false,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : user ?? this.user,
      error: clearError ? null : error ?? this.error,
    );
  }
}
