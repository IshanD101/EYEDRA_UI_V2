class UserNotification {
  final String title;
  final bool isRead;
  final DateTime timestamp;

  UserNotification({
    required this.title,
    this.isRead = false,
    required this.timestamp,
  });

  static List<UserNotification> get dummyNotifications => [
        UserNotification(
          title: 'User 1 joined campfire Session',
          timestamp: DateTime.now(),
        ),
        UserNotification(
          title: 'User 2 joined campfire session 2',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        UserNotification(
          title: 'User 3 joined campfire session 3',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

  UserNotification copyWith({bool? isRead}) {
    return UserNotification(
      title: title,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp,
    );
  }
}
