import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Delete token (for logout)
  Future<void> removeToken() async {
    await _storage.delete(key: 'jwt_token');
  }
}
