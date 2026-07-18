import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const tokenKey = 'access_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: tokenKey);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
