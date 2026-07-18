import 'package:krishi_social/features/auth/data/dto/register_request.dart';
import 'package:krishi_social/features/auth/data/model/user_model.dart';

import '../dto/login_request.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginRequest request);

  Future<UserModel> register(RegisterRequest request);
}
