class CommunityGroup {
  final String id;
  final String name;
  final String imageUrl;
  final String? description;
  final int? memberCount;

  CommunityGroup({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    this.memberCount,
  });
}