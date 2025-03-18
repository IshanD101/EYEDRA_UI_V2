import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/group.dart';
import '../models/group_member.dart';
import '../widgets/group_details_dialog.dart';
import '../widgets/add_member_dialog.dart';
import '../widgets/admin_control_panel.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  final Group group;
  final Function(GroupMember) onMemberAdded;
  final Function(GroupMember, bool, [String?]) onMemberBanStatusChanged;
  final Function(String, bool) onMemberAdminStatusChanged;
  final Function(String) onMemberRemoved;
  final Function(GroupMember) onMemberUpdated;

  const GlassAppBar({
    Key? key,
    required this.title,
    required this.onBackPressed,
    required this.group,
    required this.onMemberAdded,
    required this.onMemberBanStatusChanged,
    required this.onMemberAdminStatusChanged,
    required this.onMemberRemoved,
    required this.onMemberUpdated,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          title: GestureDetector(
            onTap: () => _showGroupDetails(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Use Flexible to handle text overflow
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.info_outline,
                  size: isSmallScreen ? 14 : 16,
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
            tooltip: 'Back',
          ),
          actions: _buildActions(context, isSmallScreen),
          titleSpacing: 0, // Reduce spacing to accommodate more items
          // Remove the flexibleSpace to fix rendering issues
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, bool isSmallScreen) {
    return [
      IconButton(
        icon: Icon(
          Icons.person_add,
          color: Colors.white.withOpacity(0.9),
          size: isSmallScreen ? 20 : 24,
        ),
        onPressed: () => _showAddMemberDialog(context),
        tooltip: 'Add member',
      ),
      if (_isCurrentUserAdmin())
        IconButton(
          icon: Icon(
            Icons.admin_panel_settings,
            color: Colors.white.withOpacity(0.9),
            size: isSmallScreen ? 20 : 24,
          ),
          onPressed: () => _showAdminPanel(context),
          tooltip: 'Admin Controls',
          // Use visualDensity to adjust icon spacing on small screens
          visualDensity:
              isSmallScreen ? VisualDensity.compact : VisualDensity.standard,
        ),
      IconButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white.withOpacity(0.9),
          size: isSmallScreen ? 20 : 24,
        ),
        onPressed: () => _showMoreOptions(context),
        tooltip: 'More options',
        visualDensity:
            isSmallScreen ? VisualDensity.compact : VisualDensity.standard,
      ),
    ];
  }

  bool _isCurrentUserAdmin() {
    // Assuming we have a way to get the current user ID
    const currentUserId = 'currentUser'; // Replace with actual current user ID
    final currentMember = group.members.firstWhere(
      (m) => m.id == currentUserId,
      orElse: () => GroupMember(id: '', name: ''),
    );
    return currentMember.isAdmin;
  }

  void _showAdminPanel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AdminControlPanel(
        group: group,
        onMemberUpdated: onMemberUpdated,
        onMemberRemoved: onMemberRemoved,
        onMemberBanStatusChanged: onMemberBanStatusChanged,
        onMemberAdminStatusChanged: onMemberAdminStatusChanged,
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
    // Get screen height for responsive bottom sheet
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allow scrolling if needed
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.7, // Limit height to 70% of screen
          ),
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
              // Add a drag handle for better UX
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
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

  Widget _buildOptionTile(
      BuildContext context, IconData icon, String label, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red[300] : Colors.white.withOpacity(0.9),
      ),
      title: Text(
        label,
        style: TextStyle(
          color:
              isDestructive ? Colors.red[300] : Colors.white.withOpacity(0.9),
        ),
      ),
      onTap: onTap,
    );
  }
}
