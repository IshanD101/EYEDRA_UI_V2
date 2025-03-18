import 'group_member.dart';

class Group {
  final String id;
  final String name;
  final String? description;
  final String? groupImageUrl;
  final DateTime createdAt;
  final List<GroupMember> members;

  Group({
    required this.id,
    required this.name,
    this.description,
    this.groupImageUrl,
    DateTime? createdAt,
    List<GroupMember>? members,
  }) :
        this.createdAt = createdAt ?? DateTime.now(),
        this.members = members ?? [];

  GroupMember? getAdmin() {
    for (final member in members) {
      if (member.isAdmin) return member;
    }
    return null;
  }
}