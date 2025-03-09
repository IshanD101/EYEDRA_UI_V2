class GroupMember {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isAdmin;

  GroupMember({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isAdmin = false,
  });
}