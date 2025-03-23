import 'dart:async';
import 'package:flutter/material.dart';
import '/models/message_model.dart';
import '/services/websocket_service.dart';
import '/services/role_service.dart';
import '/widgets/chat_message.dart';
import '/widgets/user_avatar.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final WebSocketService _webSocketService = WebSocketService();
  late Stream<Map<String, dynamic>> _chatStream;
  List<Message> _messages = [];
  UIPermissions? _permissions;
  bool _isConnecting = true;
  String? _selectedMessageId;
  String? _selectedUserId;
  bool _showModeration = false;

  @override
  void initState() {
    super.initState();
    _connectToChat();
    _loadPermissions();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _webSocketService.disconnectFromGroup();
    super.dispose();
  }

  Future<void> _loadPermissions() async {
    final permissions = await UIPermissions.fromRole();
    setState(() {
      _permissions = permissions;
    });
  }

  Future<void> _connectToChat() async {
    setState(() {
      _isConnecting = true;
    });

    try {
      _chatStream = await _webSocketService.connectToGroup(widget.groupId);
      _chatStream.listen((data) {
        _handleIncomingMessage(data);
      });

      setState(() {
        _isConnecting = false;
      });
    } catch (e) {
      print('Error connecting to chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to chat. Please try again.')),
      );
      setState(() {
        _isConnecting = false;
      });
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    if (data['type'] == 'message') {
      final message = Message.fromJson(data);
      setState(() {
        _messages.add(message);
      });
      _scrollToBottom();
    } else if (data['type'] == 'moderation') {
      // Handle moderation actions
      if (data['action'] == 'delete_message') {
        setState(() {
          _messages.removeWhere((msg) => msg.id == data['messageId']);
        });
      } else if (data['action'] == 'ban_user') {
        final userId = data['targetUserId'];
        setState(() {
          // Filter out all messages from banned user
          _messages.removeWhere((msg) => msg.userId == userId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('A user has been banned from this group')),
        );
      }
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _webSocketService.sendMessage(message);
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showModerationMenu(Message message) {
    setState(() {
      _selectedMessageId = message.id;
      _selectedUserId = message.userId;
      _showModeration = true;
    });
  }

  void _deleteMessage() {
    if (_selectedMessageId != null && _selectedUserId != null) {
      _webSocketService.sendModeration('delete_message', _selectedUserId!, _selectedMessageId);
      setState(() {
        _showModeration = false;
        _selectedMessageId = null;
        _selectedUserId = null;
      });
    }
  }

  void _banUser() {
    if (_selectedUserId != null) {
      _webSocketService.sendModeration('ban_user', _selectedUserId!, null);
      setState(() {
        _showModeration = false;
        _selectedMessageId = null;
        _selectedUserId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _connectToChat,
          ),
        ],
      ),
      body: _isConnecting
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Chat messages area
          Expanded(
            child: _messages.isEmpty
                ? Center(
              child: Text(
                "No messages yet. Be the first to say hello!",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatMessage(
                  message: message,
                  isOwn: message.isCurrentUser,
                  showModeration: _permissions?.canModerate ?? false,
                  onModerate: () => _showModerationMenu(message),
                );
              },
            ),
          ),

          // Moderation panel
          if (_showModeration && _permissions?.canModerate == true)
            Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text("Moderation Actions:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete, size: 16),
                    label: Text("Delete Message"),
                    onPressed: _deleteMessage,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: Icon(Icons.block, size: 16),
                    label: Text("Ban User"),
                    onPressed: _banUser,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => setState(() => _showModeration = false),
                  ),
                ],
              ),
            ),

          // Message input area
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}