class CommunityGroup {
  final String id;
  final String name;
  final String imageUrl;
  final String? description;
  final int? memberCount;
  final DateTime? createdAt;

  CommunityGroup({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    this.memberCount,
    this.createdAt,
  });

  factory CommunityGroup.fromJson(Map<String, dynamic> json) {
    return CommunityGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'],
      memberCount: json['memberCount'],
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'memberCount': memberCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  CommunityGroup copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    int? memberCount,
    DateTime? createdAt,
  }) {
    return CommunityGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}