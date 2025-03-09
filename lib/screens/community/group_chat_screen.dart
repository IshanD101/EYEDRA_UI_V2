import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: Text(widget.groupName,
            style: const TextStyle(color: Colors.white)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _buildChatBubble('Hello everyone!', isMe: false, senderName: 'Jane'),
                _buildChatBubble('Hi there! How is it going?', isMe: true),
                _buildChatBubble('Great! Just enjoying the group discussions.', isMe: false, senderName: 'Jane'),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String message, {required bool isMe, String? senderName}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (senderName != null)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Text(
                  senderName,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 12,
                  ),
                ),
              ),
            GlassmorphicContainer(
              width: 220,
              height: 60,  // Fixed height to avoid null height issues
              borderRadius: 15,
              blur: 10,
              border: 1,
              linearGradient: LinearGradient(
                colors: isMe
                    ? [Colors.blueAccent.withOpacity(0.2), Colors.blueAccent.withOpacity(0.05)]
                    : [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderGradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.1)],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Colors.blueGrey.shade800,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo, color: Colors.white70),
            onPressed: () {
              // Simple UI feedback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image upload feature coming soon!')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.blueGrey.shade700,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8.0),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                // Just clear text for front-end demo
                _messageController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}