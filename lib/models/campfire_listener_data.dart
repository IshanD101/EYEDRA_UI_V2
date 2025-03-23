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
      // Added a small delay to simulate network request
      await Future.delayed(const Duration(milliseconds: 800));

      return [
        Session(
          id: '1',
          title: 'Mindful Yoga for Stress Relief',
          host: Host(
            id: 'h1',
            name: 'Sarah Johnson',
            role: 'Senior Counselor',
            imageUrl: '',
            members: 6,
            bio: 'Counseling professional with 3+ years of experience in mindfulness and stress management techniques.',
          ),
          startTime: '10:00 AM',
          category: 'Yoga & Mindfulness',
          isLive: true,
        ),
        Session(
          id: '2',
          title: 'Deep Meditation Practice',
          host: Host(
            id: 'h2',
            name: 'Ishan Patel',
            role: 'Meditation Guide',
            imageUrl: '',
            members: 4,
            bio: 'Certified meditation instructor with 8+ years of experience in guided meditation and breathing techniques.',
          ),
          startTime: '11:30 AM',
          category: 'Meditation',
          isLive: false,
        ),
        Session(
          id: '3',
          title: 'Anxiety Management',
          host: Host(
            id: 'h3',
            name: 'Emma Chen',
            role: 'Clinical Psychologist',
            imageUrl: '',
            members: 8,
            bio: 'Specializing in anxiety and stress disorders with a holistic approach to mental wellness.',
          ),
          startTime: '2:00 PM',
          category: 'Mental Health',
          isLive: false,
        ),
        Session(
          id: '4',
          title: 'Sound Healing Journey',
          host: Host(
            id: 'h4',
            name: 'Miguel Santos',
            role: 'Sound Therapist',
            imageUrl: '',
            members: 12,
            bio: 'Creating therapeutic sound experiences to promote relaxation and inner balance.',
          ),
          startTime: '4:30 PM',
          category: 'Sound Therapy',
          isLive: true,
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch sessions: $e');
    }
  }
}