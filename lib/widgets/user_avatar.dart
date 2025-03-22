import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String username;
  final double size;

  const UserAvatar({
    Key? key,
    this.avatarUrl,
    required this.username,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get initials from username
    final initials = username.isNotEmpty
        ? username.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
        : '?';

    // Generate color based on username
    final hash = username.hashCode;
    final color = Colors.primaries[hash % Colors.primaries.length];

    return avatarUrl != null && avatarUrl!.isNotEmpty
        ? CircleAvatar(
      radius: size / 2,
      backgroundImage: NetworkImage(avatarUrl!),
    )
        : CircleAvatar(
      radius: size / 2,
      backgroundColor: color,
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size / 2.5,
        ),
      ),
    );
  }
}