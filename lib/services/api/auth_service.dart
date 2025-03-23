import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

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

  // Save user role
  Future<void> saveUserRole(String role) async {
    await _storage.write(key: 'user_role', value: role);
  }

  // Get user role
  Future<String> getUserRole() async {
    return await _storage.read(key: 'user_role') ?? 'Normal_user';
  }

  // Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  // Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    if (userData.containsKey('id')) {
      await _storage.write(key: 'user_id', value: userData['id'].toString());
    }

    if (userData.containsKey('role')) {
      await _storage.write(key: 'user_role', value: userData['role']);
    }

    if (userData.containsKey('username')) {
      await _storage.write(key: 'username', value: userData['username']);
    }

    // Store the entire user data as JSON for potential future use
    await _storage.write(key: 'user_data', value: jsonEncode(userData));
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Get username
  Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  // For token refresh functionality (to be implemented)
  Future<bool> refreshToken() async {
    // This would typically make an API call to refresh the token
    // For now, we'll just return true assuming token is still valid
    return true;
  }
}