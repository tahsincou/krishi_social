import 'package:flutter_mvp_starter/features/auth/data/dto/login_request.dart';
import 'package:flutter_mvp_starter/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<User> login(LoginRequest request);

  Future<void> logout();

  Future<User?> currentUser();
}
