import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/group.dart';
import '../models/group_member.dart';
import '../widgets/group_details_dialog.dart';
import '../widgets/add_member_dialog.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  final Group group;
  final Function(GroupMember) onMemberAdded;

  const GlassAppBar({
    Key? key,
    required this.title,
    required this.onBackPressed,
    required this.group,
    required this.onMemberAdded,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => _showGroupDetails(context),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900]?.withOpacity(0.7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.person_add,
            color: Colors.white.withOpacity(0.9),
          ),
          onPressed: () => _showAddMemberDialog(context),
          tooltip: 'Add member',
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white.withOpacity(0.9),
          ),
          onPressed: () {
            // Show more options menu
            _showMoreOptions(context);
          },
        ),
      ],
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  void _showGroupDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => GroupDetailsDialog(group: group),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddMemberDialog(
        onMemberAdded: onMemberAdded,
        existingMemberIds: group.members.map((m) => m.id).toList(),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionTile(
                context,
                Icons.edit,
                'Edit group info',
                    () => Navigator.pop(context),
              ),
              _buildOptionTile(
                context,
                Icons.notifications,
                'Mute notifications',
                    () => Navigator.pop(context),
              ),
              _buildOptionTile(
                context,
                Icons.exit_to_app,
                'Leave group',
                    () => Navigator.pop(context),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red[300] : Colors.white.withOpacity(0.9),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.red[300] : Colors.white.withOpacity(0.9),
        ),
      ),
      onTap: onTap,
    );
  }
}