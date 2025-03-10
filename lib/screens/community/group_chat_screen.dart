import 'package:flutter/material.dart';
import 'dart:ui';
import '/models/message.dart';
import '/models/group.dart';
import '/models/group_member.dart';
import '/widgets/chat_bubble.dart';
import '/widgets/message_input.dart';
import '/widgets/glass_app_bar.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatScreen({
    Key? key,
    required this.groupId,
    required this.groupName
  }) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late Group _group;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _loadGroupData();
  }

  void _loadGroupData() {
    // In a real app, this would fetch from an API or database
    _group = Group(
      id: widget.groupId,
      name: widget.groupName,
      description: 'A group for team discussions and updates',
      members: [
        GroupMember(
          id: 'currentUser',
          name: 'You',
          isAdmin: true,
        ),
        GroupMember(
          id: 'jane',
          name: 'Jane',
        ),
      ],
    );
  }

  void _loadInitialMessages() {
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          text: 'Hello everyone!',
          isFromMe: false,
          senderName: 'Jane',
          senderId: 'jane',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        ChatMessage(
          id: '2',
          text: 'Hi there! How is it going?',
          isFromMe: true,
          senderId: 'currentUser',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        ChatMessage(
          id: '3',
          text: 'Great! Just enjoying the group discussions.',
          isFromMe: false,
          senderName: 'Jane',
          senderId: 'jane',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
      ]);
    });
  }

  void _handleSendMessage(String text) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromMe: true,
      senderId: 'currentUser',
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
    });

    // Here you would typically send the message to your backend
  }

  void _handleAddMember(GroupMember newMember) {
    setState(() {
      _group.members.add(newMember);
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newMember.name} added to the group'),
        backgroundColor: Colors.green[800],
      ),
    );

    // In a real app, you would update this on your backend
  }

  bool get isCurrentUserAdmin {
    // Check if current user is an admin
    return _group.members.any((m) => m.id == 'currentUser' && m.isAdmin);
  }

  void _handleDeleteMessage(ChatMessage message) {
    if (!isCurrentUserAdmin) return;
    final int index = _messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      setState(() {
        _messages[index] = message.copyWith(
          isDeleted: true,
          deletedBy: 'currentUser',
          deletedAt: DateTime.now(),
        );
      });
      // In a real app, notify backend of message deletion
    }
  }

  void _handleBanMember(GroupMember member, bool isBanned, [String? reason]) {
    if (!isCurrentUserAdmin) return;
    final int index = _group.members.indexWhere((m) => m.id == member.id);
    if (index != -1) {
      setState(() {
        _group.members[index] = member.copyWith(
          isBanned: isBanned,
          bannedAt: isBanned ? DateTime.now() : null,
          bannedBy: isBanned ? 'currentUser' : null,
          banReason: isBanned ? reason : null,
        );
      });
      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isBanned ? '${member.name} has been banned from the group' : '${member.name} has been unbanned'),
          backgroundColor: isBanned ? Colors.red[800] : Colors.green[800],
        ),
      );
      // In a real app, notify backend of ban status change
    }
  }

  void _handleToggleAdminStatus(String memberId, bool isAdmin) {
    if (!isCurrentUserAdmin) return;
    final int index = _group.members.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      setState(() {
        _group.members[index] = _group.members[index].copyWith(
          isAdmin: isAdmin,
        );
      });
      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAdmin ? '${_group.members[index].name} is now an admin' : '${_group.members[index].name} is no longer an admin'),
          backgroundColor: Colors.blue[800],
        ),
      );
      // In a real app, notify backend of admin status change
    }
  }

  void _handleMemberRemoved(String memberId) {
    if (!isCurrentUserAdmin) return;
    final int index = _group.members.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      final removedMemberName = _group.members[index].name;
      setState(() {
        _group.members.removeAt(index);
      });
      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$removedMemberName has been removed from the group'),
          backgroundColor: Colors.orange[800],
        ),
      );
      // In a real app, notify backend
    }
  }

  void _handleMemberUpdated(GroupMember updatedMember) {
    if (!isCurrentUserAdmin) return;
    final int index = _group.members.indexWhere((m) => m.id == updatedMember.id);
    if (index != -1) {
      setState(() {
        _group.members[index] = updatedMember;
      });
      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedMember.name}\'s information has been updated'),
          backgroundColor: Colors.blue[800],
        ),
      );
      // In a real app, notify backend
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: GlassAppBar(
        title: widget.groupName,
        onBackPressed: () => Navigator.pop(context),
        group: _group,
        onMemberAdded: _handleAddMember,
        onMemberBanStatusChanged: _handleBanMember,
        onMemberAdminStatusChanged: _handleToggleAdminStatus,
        onMemberRemoved: _handleMemberRemoved,
        onMemberUpdated: _handleMemberUpdated,
      ),
      body: Stack(
        children: [
          _buildBackground(),
          _buildChatContent(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[900]!.withOpacity(0.3),
            Colors.black,
          ],
        ),
      ),
    );
  }

  Widget _buildChatContent() {
    return Column(
      children: [
        SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 10), // Adjusted height
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ChatBubble(
                message: _messages[index],
                isCurrentUserAdmin: isCurrentUserAdmin,
                onMessageDelete: _handleDeleteMessage,
              );
            },
          ),
        ),
        MessageInput(
          controller: _messageController,
          onSendMessage: _handleSendMessage,
        ),
      ],
    );
  }
}