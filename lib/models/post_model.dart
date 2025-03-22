class Post {
  final String username;
  final String content;
  final String imageUrl;
  int likes;
  int shares;

  Post({
    required this.username,
    required this.content,
    required this.imageUrl,
    this.likes = 0,
    this.shares = 0,
  });

  // Factory constructor to create a Post from a JSON map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      likes: json['likes'] as int? ?? 0,
      shares: json['shares'] as int? ?? 0,
    );
  }

  // Method to convert Post to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'shares': shares,
    };
  }
}