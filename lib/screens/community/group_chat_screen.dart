import 'package:flutter/material.dart';
import 'dart:ui';
import '/models/message.dart';
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

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    // This would typically fetch messages from a database or API
    setState(() {
      _messages.addAll([
        ChatMessage(
          text: 'Hello everyone!',
          isFromMe: false,
          senderName: 'Jane',
        ),
        ChatMessage(
          text: 'Hi there! How is it going?',
          isFromMe: true,
        ),
        ChatMessage(
          text: 'Great! Just enjoying the group discussions.',
          isFromMe: false,
          senderName: 'Jane',
        ),
      ]);
    });
  }

  void _handleSendMessage(String text) {
    final newMessage = ChatMessage(
      text: text,
      isFromMe: true,
    );

    setState(() {
      _messages.add(newMessage);
    });

    // Here you would typically send the message to your backend
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
        SizedBox(height: AppBar().preferredSize.height + 20),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ChatBubble(message: _messages[index]);
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