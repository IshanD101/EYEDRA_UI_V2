import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  final String username;
  final String content;
  final String imageUrl;

  Post({required this.username, required this.content, required this.imageUrl});

  // Factory method to create Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  // Fetch data from the API
  static Future<List<Post>> fetchPosts() async {
    const String apiUrl = ''; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}
