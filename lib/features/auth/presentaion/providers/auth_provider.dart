import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvp_starter/core/providers/providers.dart';
import 'package:flutter_mvp_starter/features/auth/domain/usecases/check_login_usecase.dart';
import 'package:flutter_mvp_starter/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_mvp_starter/features/auth/domain/usecases/logout_usecase.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final checkLoginUseCaseProvider = Provider<CheckLoginUseCase>((ref) {
  return CheckLoginUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});
