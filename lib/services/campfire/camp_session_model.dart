class CampSession {
  final String sessionId;
  final String title;
  final String category;
  final String startTime;
  final CampHost host;
  final int participantCount;

  CampSession({
    required this.sessionId,
    required this.title,
    required this.category,
    required this.startTime,
    required this.host,
    required this.participantCount,
  });

  factory CampSession.fromJson(Map<String, dynamic> json) {
    return CampSession(
      sessionId: json['sessionId'] ?? '',
      title: json['title'] ?? 'Untitled Session',
      category: json['category'] ?? 'General',
      startTime: json['startTime'] ?? 'Now',
      host: CampHost.fromJson(json['host'] ?? {}),
      participantCount: json['participantCount'] ?? 0,
    );
  }
}

class CampHost {
  final String name;
  final String role;
  final String imageUrl;
  final String? bio;

  CampHost({
    required this.name,
    required this.role,
    required this.imageUrl,
    this.bio,
  });

  factory CampHost.fromJson(Map<String, dynamic> json) {
    return CampHost(
      name: json['name'] ?? 'Unknown Host',
      role: json['role'] ?? 'Host',
      imageUrl: json['imageUrl'] ?? '',
      bio: json['bio'],
    );
  }
}