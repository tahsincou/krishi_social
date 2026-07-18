import 'package:krishi_social/features/auth/data/dto/login_request.dart';
import 'package:krishi_social/features/auth/data/repository/auth_repository.dart';

import '../entities/user.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<User> call(LoginRequest request) {
    return repository.login(request);
  }
}
