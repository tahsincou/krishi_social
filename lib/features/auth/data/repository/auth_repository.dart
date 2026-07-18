import 'package:krishi_social/features/auth/data/dto/login_request.dart';
import 'package:krishi_social/features/auth/data/dto/register_request.dart';
import 'package:krishi_social/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<User> login(LoginRequest request);

  Future<void> logout();

  Future<User?> currentUser();

  Future<User> register(RegisterRequest request);
}
