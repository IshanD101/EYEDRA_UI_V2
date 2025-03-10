import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUserAdmin;
  final Function(ChatMessage)? onMessageDelete;

  const ChatBubble({
    Key? key,
    required this.message,
    this.isCurrentUserAdmin = false,
    this.onMessageDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isFromMe
              ? Colors.blue[700]?.withOpacity(0.9)
              : Colors.grey[800]?.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isFromMe && message.senderName != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 0),
                  child: Text(
                    message.senderName!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              GestureDetector(
                onLongPress: isCurrentUserAdmin && !message.isDeleted && onMessageDelete != null
                    ? () => _showDeleteDialog(context)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: message.isDeleted
                      ? Text(
                    'This message was deleted',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  )
                      : Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Delete Message',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        content: Text(
          'Are you sure you want to delete this message? This action cannot be undone.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue[300],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onMessageDelete?.call(message);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}