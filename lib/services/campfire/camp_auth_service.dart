import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Replace with your actual auth server URL
  static const String authUrl = 'http://localhost:5000/api';

  // Store token in SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save user info
  static Future<void> saveUserInfo(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_info', json.encode(user));
  }

  // Get user info
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_info');
    if (userJson != null) {
      return json.decode(userJson);
    }
    return null;
  }

  // For demo/development, create mock user if no auth server is available
  static Future<Map<String, dynamic>> createMockUser(String name, String role) async {
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final mockUser = {
      'userId': userId,
      'name': name.isEmpty ? 'Anonymous User' : name,
      'role': role.isEmpty ? 'user' : role,
      'imageUrl': ''
    };

    await saveUserInfo(mockUser);
    await saveToken('mock_token_$userId'); // Save a mock token

    return mockUser;
  }
}