import '../storage/secure_storage_service.dart';

class AuthService {
  final SecureStorageService storage;

  AuthService(this.storage);

  Future<bool> isLoggedIn() async {
    final token = await storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await storage.clear();
  }
}
