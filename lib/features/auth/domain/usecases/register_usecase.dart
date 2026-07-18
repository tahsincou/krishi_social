import 'package:krishi_social/features/auth/data/dto/register_request.dart';
import 'package:krishi_social/features/auth/data/repository/auth_repository.dart';
import 'package:krishi_social/features/auth/domain/entities/user.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<User> call(RegisterRequest request) {
    return repository.register(request);
  }
}
