import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/models/user_notifications.dart'; // Import the UserNotification model

class NotificationTile extends StatelessWidget {
  final UserNotification notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification.title),
      subtitle: Text(
        notification.timestamp.toString(), // Display timestamp
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: notification.isRead
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(
              Icons.circle,
              color: Colors.red,
              size: 10,
            ),
    );
  }
}
