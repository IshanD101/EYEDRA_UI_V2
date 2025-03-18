import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/group.dart';
import '../models/group_member.dart';
import 'ban_member_dialog.dart';

class AdminControlPanel extends StatefulWidget {
  final Group group;
  final Function(GroupMember) onMemberUpdated;
  final Function(String memberId) onMemberRemoved;
  final Function(GroupMember, bool) onMemberBanStatusChanged;
  final Function(String memberId, bool) onMemberAdminStatusChanged;

  const AdminControlPanel({
    Key? key,
    required this.group,
    required this.onMemberUpdated,
    required this.onMemberRemoved,
    required this.onMemberBanStatusChanged,
    required this.onMemberAdminStatusChanged,
  }) : super(key: key);

  @override
  _AdminControlPanelState createState() => _AdminControlPanelState();
}

class _AdminControlPanelState extends State<AdminControlPanel> {
  void _showBanDialog(GroupMember member) {
    showDialog(
      context: context,
      builder: (context) => BanMemberDialog(
        member: member,
        onBanConfirmed: (reason) {
          widget.onMemberBanStatusChanged(member, true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 600,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Expanded(
                child: _buildMembersList(),
              ),
              _buildCloseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.admin_panel_settings, color: Colors.blue[300], size: 24),
          const SizedBox(width: 12),
          Text(
            'Admin Control Panel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    final activeMembers = widget.group.members.where((m) => !m.isBanned).toList();
    final bannedMembers = widget.group.members.where((m) => m.isBanned).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...activeMembers.map((member) => _buildMemberTile(member)),
          if (bannedMembers.isNotEmpty) ...[
            const Divider(color: Colors.white10),
            ...bannedMembers.map((member) => _buildMemberTile(member)),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberTile(GroupMember member) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: CircleAvatar(
        backgroundColor: member.isBanned
            ? Colors.red.withOpacity(0.2)
            : Colors.blue.withOpacity(0.2),
        child: Text(
          member.name.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
      ),
      title: Text(
        member.name,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          decoration: member.isBanned ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              member.isAdmin ? Icons.star : Icons.star_border,
              color: member.isAdmin ? Colors.amber : Colors.white.withOpacity(0.5),
              size: 20,
            ),
            tooltip: member.isAdmin ? 'Remove admin' : 'Make admin',
            onPressed: () {
              setState(() {
                widget.onMemberAdminStatusChanged(member.id, !member.isAdmin);
              });
            },
          ),
          IconButton(
            icon: Icon(
              member.isBanned ? Icons.person_add : Icons.block,
              color: member.isBanned ? Colors.green[300] : Colors.red[300],
              size: 20,
            ),
            tooltip: member.isBanned ? 'Unban member' : 'Ban member',
            onPressed: () {
              if (member.isBanned) {
                widget.onMemberBanStatusChanged(member, false);
              } else {
                _showBanDialog(member);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900]?.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.blue.withOpacity(0.3),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
        ),
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
