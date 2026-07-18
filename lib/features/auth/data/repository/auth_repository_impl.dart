import 'dart:convert';

import 'package:krishi_social/features/auth/data/dto/register_request.dart';
import 'package:krishi_social/features/auth/data/model/user_model.dart';
import 'package:krishi_social/features/auth/data/repository/auth_repository.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user.dart';
import '../datasource/auth_remote_datasource.dart';
import '../dto/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final SecureStorageService storage;

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<User> login(LoginRequest request) async {
    final user = await remote.login(request);

    await storage.saveToken(user.token);
    await storage.saveUser(jsonEncode(user.toJson()));

    return user;
  }

  @override
  Future<void> logout() async {
    await storage.deleteUser();
  }

  @override
  Future<User?> currentUser() async {
    final token = await storage.getToken();
    final userJson = await storage.getUser();

    if (token == null ||
        token.isEmpty ||
        userJson == null ||
        userJson.isEmpty) {
      return null;
    }

    final json = jsonDecode(userJson) as Map<String, dynamic>;

    return UserModel.fromJson({...json, 'token': token});
  }

  @override
  Future<User> register(RegisterRequest request) async {
    final user = await remote.register(request);

    await storage.saveToken(user.token);
    await storage.saveUser(jsonEncode(user.toJson()));

    return user;
  }
}
