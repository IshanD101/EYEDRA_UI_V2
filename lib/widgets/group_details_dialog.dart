import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/group.dart';

class GroupDetailsDialog extends StatelessWidget {
  final Group group;

  const GroupDetailsDialog({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGroupHeader(),
              if (group.description != null) _buildGroupDescription(),
              const Divider(
                color: Colors.white24,
                thickness: 0.5,
              ),
              _buildMembersList(),
              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue[900]?.withOpacity(0.2),
            child: group.groupImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(group.groupImageUrl!),
                  )
                : Text(
                    group.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            group.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Created ${_formatDate(group.createdAt)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        group.description!,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.7),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMembersList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: group.members.length,
        itemBuilder: (context, index) {
          final member = group.members[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[800]?.withOpacity(0.2),
              child: member.avatarUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(member.avatarUrl!),
                    )
                  : Text(
                      member.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
            ),
            title: Text(
              member.name,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            trailing: member.isAdmin
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[900]?.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[300],
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
