import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  final FlutterSecureStorage storage;

  const SecureStorageService(this.storage);

  Future<void> saveToken(String token) {
    return storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() {
    return storage.read(key: _tokenKey);
  }

  Future<void> saveUser(String userJson) {
    return storage.write(key: _userKey, value: userJson);
  }

  Future<String?> getUser() {
    return storage.read(key: _userKey);
  }

  Future<void> deleteUser() {
    return storage.delete(key: _userKey);
  }

  Future<void> deleteToken() {
    return storage.delete(key: _tokenKey);
  }
}
