import 'dart:convert';
import 'package:http/http.dart' as http;
import './auth_service.dart';

class ApiService {
  final String baseUrl = 'https://your-api-url.com/api'; // Replace with your API URL
  final AuthService _authService = AuthService();

  // Get request with authentication
  Future<dynamic> get(String endpoint) async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      // Handle unauthorized access - token might be expired
      final refreshSuccess = await _authService.refreshToken();
      if (refreshSuccess) {
        return get(endpoint); // Retry with new token
      } else {
        throw Exception('Authentication failed');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // Post request with authentication
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      // Handle unauthorized access - token might be expired
      final refreshSuccess = await _authService.refreshToken();
      if (refreshSuccess) {
        return post(endpoint, data); // Retry with new token
      } else {
        throw Exception('Authentication failed');
      }
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  // Delete request with authentication
  Future<dynamic> delete(String endpoint) async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.statusCode == 200 ? json.decode(response.body) : null;
    } else if (response.statusCode == 401) {
      // Handle unauthorized access - token might be expired
      final refreshSuccess = await _authService.refreshToken();
      if (refreshSuccess) {
        return delete(endpoint); // Retry with new token
      } else {
        throw Exception('Authentication failed');
      }
    } else {
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }

  // Put request with authentication
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      // Handle unauthorized access - token might be expired
      final refreshSuccess = await _authService.refreshToken();
      if (refreshSuccess) {
        return put(endpoint, data); // Retry with new token
      } else {
        throw Exception('Authentication failed');
      }
    } else {
      throw Exception('Failed to update data: ${response.statusCode}');
    }
  }
}