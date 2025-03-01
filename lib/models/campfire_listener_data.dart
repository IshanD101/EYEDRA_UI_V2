class Host {
  final String id;
  final String name;
  final String role;
  final String imageUrl;
  final int members;
  final String? bio;
  final String? email;

  Host({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.members,
    this.bio,
    this.email,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      imageUrl: json['image_url'] as String,
      members: json['listeners'] as int,
      bio: json['bio'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'image_url': imageUrl,
      'listeners': members,
      'bio': bio,
      'email': email,
    };
  }
}

class Session {
  final String id;
  final String title;
  final Host host;
  final String startTime;
  final String category;
  final String? description;
  final int? maxParticipants;
  final bool isLive;

  Session({
    required this.id,
    required this.title,
    required this.host,
    required this.startTime,
    required this.category,
    this.description,
    this.maxParticipants,
    this.isLive = false,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      title: json['title'] as String,
      host: Host.fromJson(json['host'] as Map<String, dynamic>),
      startTime: json['start_time'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      maxParticipants: json['max_participants'] as int?,
      isLive: json['is_live'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'host': host.toJson(),
      'start_time': startTime,
      'category': category,
      'description': description,
      'max_participants': maxParticipants,
      'is_live': isLive,
    };
  }
}

class SessionService {
  static Future<List<Session>> fetchSessions() async {
    try {
      return [
        Session(
          id: '1',
          title: 'Mindful Yoga',
          host: Host(
            id: 'h1',
            name: 'Sarah',
            role: 'Senior Councellor',
            imageUrl: 'https://example.com/sarah.jpg',
            members: 6,
            bio: 'Councelling with 3+ years of experience.',
          ),
          startTime: '10:00 AM',
          category: 'Yoga',
          isLive: true,
        ),
        Session(
          id: '2',
          title: 'Meditate',
          host: Host(
            id: 'h2',
            name: 'Ishan',
            role: 'Councellor',
            imageUrl: 'https://example.com/michael.jpg',
            members: 4,
            bio: 'Councelling with 8+ years of experience.',
          ),
          startTime: '11:30 AM',
          category: 'Meditation',
          isLive: false,
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch sessions: $e');
    }
  }
}
