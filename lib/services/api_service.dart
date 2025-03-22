import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://your-api-url.com/api'; // Replace with your API URL
  final AuthService _authService = AuthService();

  // Get headers with authentication token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Handle response and token refresh if needed
  Future<dynamic> _handleResponse(http.Response response, Function retryCallback) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body.isNotEmpty ? json.decode(response.body) : null;
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 401) {
      // Handle unauthorized access - token might be expired
      final refreshSuccess = await _authService.refreshToken();
      if (refreshSuccess) {
        return retryCallback(); // Retry with new token
      } else {
        throw Exception('Authentication failed');
      }
    } else {
      throw Exception('Request failed: ${response.statusCode}, ${response.body}');
    }
  }

  // Generic GET request
  Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );

    return _handleResponse(response, () => get(endpoint));
  }

  // Generic POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: json.encode(data),
    );

    return _handleResponse(response, () => post(endpoint, data));
  }

  // Generic PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: json.encode(data),
    );

    return _handleResponse(response, () => put(endpoint, data));
  }

  // Generic DELETE request
  Future<dynamic> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );

    return _handleResponse(response, () => delete(endpoint));
  }

  // Multipart request for file uploads
  Future<dynamic> uploadFile(String endpoint, Map<String, String> fields, Map<String, File> files) async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$endpoint'),
    );

    // Add authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Add text fields
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add files
    for (var fileEntry in files.entries) {
      request.files.add(await http.MultipartFile.fromPath(
        fileEntry.key,
        fileEntry.value.path,
      ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, () => uploadFile(endpoint, fields, files));
  }

  // User-specific endpoints
  Future<Map<String, dynamic>> getUserProfile() async {
    return await get('users/profile');
  }

  Future<bool> updateProfile(String name, String bio) async {
    final response = await put('users/profile', {
      'name': name,
      'bio': bio,
    });

    return response != null;
  }

  Future<List<dynamic>> getUserPosts() async {
    final response = await get('posts/user');

    if (response is List) {
      return response;
    } else {
      return [];
    }
  }

  Future<bool> createPost(String title, String description, File? image) async {
    if (image == null) {
      final response = await post('posts', {
        'title': title,
        'description': description,
      });
      return response != null;
    } else {
      final response = await uploadFile(
        'posts',
        {'title': title, 'description': description},
        {'image': image},
      );
      return response != null;
    }
  }

  // Authentication
  Future<void> signOut() async {
    await _authService.removeToken();
    // You might want to call a logout endpoint on your backend here
    try {
      await post('auth/logout', {});
    } catch (e) {
      // Ignore errors during logout
    }
  }
}