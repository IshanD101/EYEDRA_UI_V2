class Message {
  final String id;
  final String content;
  final String userId;
  final String username;
  final String? userAvatar;
  final DateTime timestamp;
  final bool isCurrentUser;

  Message({
    required this.id,
    required this.content,
    required this.userId,
    required this.username,
    this.userAvatar,
    required this.timestamp,
    this.isCurrentUser = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? 'Unknown',
      userAvatar: json['userAvatar'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isCurrentUser: json['isCurrentUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'username': username,
      'userAvatar': userAvatar,
      'timestamp': timestamp.toIso8601String(),
      'isCurrentUser': isCurrentUser,
    };
  }
}