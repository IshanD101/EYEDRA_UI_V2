// widgets/ban_member_dialog.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/group_member.dart';

class BanMemberDialog extends StatefulWidget {
  final GroupMember member;
  final Function(String? reason) onBanConfirmed;

  const BanMemberDialog({
    Key? key,
    required this.member,
    required this.onBanConfirmed,
  }) : super(key: key);

  @override
  State<BanMemberDialog> createState() => _BanMemberDialogState();
}

class _BanMemberDialogState extends State<BanMemberDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildUserInfo(),
              const SizedBox(height: 16),
              _buildReasonInput(),
              const SizedBox(height: 24),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.block,
          color: Colors.red[300],
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          'Ban Member',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.red.withOpacity(0.2),
          child: Text(
            widget.member.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.member.name,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'This will prevent the user from sending messages',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReasonInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for ban (optional):',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _reasonController,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
            ),
            decoration: InputDecoration(
              hintText: 'e.g. Violated group rules',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onBanConfirmed(_reasonController.text.isEmpty ? null : _reasonController.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700]?.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Ban Member',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
      ],
    );
  }
}