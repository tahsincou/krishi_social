import 'package:flutter_mvp_starter/features/auth/data/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
