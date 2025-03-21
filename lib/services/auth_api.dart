import 'dart:convert';
import 'package:http/http.dart' as http;
import './auth_servcie.dart';

class AuthApi {
  final AuthService _authService = AuthService();
  final String apiUrl = ''; // Update URL

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        await _authService.saveToken(token);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print(e);
    }
  }
}
