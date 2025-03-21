import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/community/group_chat_screen.dart';

class CommunityCard extends StatelessWidget {
  final String groupId;
  final String groupName;
  final String description;
  final int members;
  final bool canDelete;
  final VoidCallback? onDelete;

  const CommunityCard({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.description,
    required this.members,
    this.canDelete = false,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatScreen(
              groupId: groupId,
              groupName: groupName,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue[900]!.withOpacity(0.3),
              child: Icon(
                Icons.group,
                size: 32,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(groupName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.people, size: 14, color: Colors.white.withOpacity(0.8)),
                      SizedBox(width: 4),
                      Text('$members members', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            if (canDelete)
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
