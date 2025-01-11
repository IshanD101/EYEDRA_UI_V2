class User {
  final String username;
  final String email;
  String? description;

  User({
    required this.username,
    required this.email,
    this.description,
  });
}
