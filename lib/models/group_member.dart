class GroupMember {
  final String id;
  final String name;
  final bool isAdmin;
  final bool isBanned;
  final DateTime? bannedAt;
  final String? bannedBy;
  final String? banReason;
  final String? avatarUrl;  // Added missing property

  GroupMember({
    required this.id,
    required this.name,
    this.isAdmin = false,
    this.isBanned = false,
    this.bannedAt,
    this.bannedBy,
    this.banReason,
    this.avatarUrl,  // Added to constructor
  });

  // Create a copy of this member with updated fields
  GroupMember copyWith({
    String? id,
    String? name,
    bool? isAdmin,
    bool? isBanned,
    DateTime? bannedAt,
    String? bannedBy,
    String? banReason,
    String? avatarUrl,  // Added to copyWith method
  }) {
    return GroupMember(
      id: id ?? this.id,
      name: name ?? this.name,
      isAdmin: isAdmin ?? this.isAdmin,
      isBanned: isBanned ?? this.isBanned,
      bannedAt: bannedAt ?? this.bannedAt,
      bannedBy: bannedBy ?? this.bannedBy,
      banReason: banReason ?? this.banReason,
      avatarUrl: avatarUrl ?? this.avatarUrl,  // Added to return statement
    );
  }
}