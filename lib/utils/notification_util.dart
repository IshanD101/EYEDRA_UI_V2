// lib/utils/notification_utils.dart
import '../models/user_notifications.dart'; // Adjust the import based on your project structure.

class NotificationUtils {
  static List<UserNotification> filterNotifications(
    List<UserNotification> notifications,
    String filter,
  ) {
    final now = DateTime.now();

    switch (filter) {
      case 'Today':
        return notifications
            .where((notif) =>
                notif.timestamp.isAfter(DateTime(now.year, now.month, now.day)))
            .toList();
      case 'Yesterday':
        return notifications
            .where((notif) =>
                notif.timestamp
                    .isAfter(DateTime(now.year, now.month, now.day - 1)) &&
                notif.timestamp
                    .isBefore(DateTime(now.year, now.month, now.day)))
            .toList();
      case 'Last 7 Days':
        return notifications
            .where((notif) =>
                notif.timestamp.isAfter(now.subtract(const Duration(days: 7))))
            .toList();
      default:
        return notifications;
    }
  }
}
