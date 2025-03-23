import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Replace with your actual backend URL
  static const String baseUrl = 'http://10.0.2.2:5000/api'; // For Android emulator
  // Use 'http://localhost:5000/api' for iOS simulator or web
  // Use your actual IP address when testing on physical devices

  // Headers for API requests
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get active sessions
  static Future<List<dynamic>> getActiveSessions() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/sessions/active'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['sessions'] ?? [];
      } else {
        throw Exception('Failed to load sessions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting sessions: $e');
      return [];
    }
  }

  // Create new session
  static Future<Map<String, dynamic>> createSession(String title, String category) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/sessions/create'),
        headers: headers,
        body: json.encode({
          'title': title,
          'category': category,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create session: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating session: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // Join existing session
  static Future<Map<String, dynamic>> joinSession(String sessionId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/sessions/join'),
        headers: headers,
        body: json.encode({
          'sessionId': sessionId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to join session: ${response.statusCode}');
      }
    } catch (e) {
      print('Error joining session: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // End session (for host)
  static Future<bool> endSession(String sessionId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/sessions/end/$sessionId'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error ending session: $e');
      return false;
    }
  }
}