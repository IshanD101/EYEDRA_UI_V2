import 'dart:convert';
import 'package:http/http.dart' as http;
import './auth_service.dart';

class AuthApi {
  final AuthService _authService = AuthService();
  final String baseUrl = 'https://your-api-url.com/api'; // Update with your actual API URL

  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save token
        if (data['token'] != null) {
          await _authService.saveToken(data['token']);
        }

        // Save user data
        if (data['user'] != null) {
          await _authService.saveUserData(data['user']);
        }

        return {'success': true, 'data': data};
      } else {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'error': errorData['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'error': 'Network error. Please try again.'};
    }
  }

  // Register
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'error': errorData['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      print('Registration error: $e');
      return {'success': false, 'error': 'Network error. Please try again.'};
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final token = await _authService.getToken();

      if (token != null) {
        // Optionally notify the server about the logout
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      // Remove token regardless of server response
      await _authService.removeToken();
    } catch (e) {
      print('Logout error: $e');
      // Still remove token even if server request fails
      await _authService.removeToken();
    }
  }

  // Get current user profile
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {'success': false, 'error': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // Update stored user data
        await _authService.saveUserData(userData);

        return {'success': true, 'data': userData};
      } else {
        return {'success': false, 'error': 'Failed to get user profile'};
      }
    } catch (e) {
      print('Get current user error: $e');
      return {'success': false, 'error': 'Network error. Please try again.'};
    }
  }
}