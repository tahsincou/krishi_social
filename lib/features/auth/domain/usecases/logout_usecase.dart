import 'package:krishi_social/features/auth/data/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
