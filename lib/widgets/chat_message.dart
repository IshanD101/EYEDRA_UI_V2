import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/message_model.dart';
import '/widgets/user_avatar.dart';

class ChatMessage extends StatelessWidget {
  final Message message;
  final bool isOwn;
  final bool showModeration;
  final VoidCallback? onModerate;

  const ChatMessage({
    Key? key,
    required this.message,
    this.isOwn = false,
    this.showModeration = false,
    this.onModerate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');
    final messageTime = timeFormat.format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwn) ...[
            UserAvatar(
              avatarUrl: message.userAvatar,
              username: message.username,
              size: 36,
            ),
            SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isOwn ? Colors.blueAccent : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwn)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        message.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOwn ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isOwn ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        messageTime,
                        style: TextStyle(
                          fontSize: 10,
                          color: isOwn ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      if (showModeration && !isOwn) ...[
                        SizedBox(width: 8),
                        InkWell(
                          onTap: onModerate,
                          child: Icon(
                            Icons.more_vert,
                            size: 12,
                            color: isOwn ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isOwn) ...[
            SizedBox(width: 8),
            UserAvatar(
              avatarUrl: message.userAvatar,
              username: message.username,
              size: 36,
            ),
          ],
        ],
      ),
    );
  }
}