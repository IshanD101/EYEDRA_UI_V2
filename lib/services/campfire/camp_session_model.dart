class Session {
  final String sessionId;
  final String title;
  final String category;
  final String startTime;
  final Host host;
  final int participantCount;

  Session({
    required this.sessionId,
    required this.title,
    required this.category,
    required this.startTime,
    required this.host,
    required this.participantCount,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['sessionId'] ?? '',
      title: json['title'] ?? 'Untitled Session',
      category: json['category'] ?? 'General',
      startTime: json['startTime'] ?? 'Now',
      host: Host.fromJson(json['host'] ?? {}),
      participantCount: json['participantCount'] ?? 0,
    );
  }
}

class Host {
  final String name;
  final String role;
  final String imageUrl;
  final String? bio;

  Host({
    required this.name,
    required this.role,
    required this.imageUrl,
    this.bio,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      name: json['name'] ?? 'Unknown Host',
      role: json['role'] ?? 'Host',
      imageUrl: json['imageUrl'] ?? '',
      bio: json['bio'],
    );
  }
}