import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/widgets/notification_tile.dart';
import 'package:eyedra_ui_v2/utils/notification_util.dart';
import 'package:eyedra_ui_v2/models/user_notifications.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  late List<UserNotification> _notifications;
  late List<UserNotification> _filteredNotifications;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _notifications = UserNotification.dummyNotifications;
    _filteredNotifications = _notifications;
  }

  void _applyFilter() {
    setState(() {
      _filteredNotifications = NotificationUtils.filterNotifications(
          _notifications, _selectedFilter);
    });
  }

  void _onFilterChanged(String? newFilter) {
    if (newFilter != null) {
      setState(() {
        _selectedFilter = newFilter;
        _applyFilter();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D47A1), // Dark Blue
                Color(0xFF1976D2), // Medium Blue
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello, User!',
                    style: textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Today', child: Text('Today')),
                      DropdownMenuItem(value: 'Yesterday', child: Text('Yesterday')),
                      DropdownMenuItem(value: 'Last 7 Days', child: Text('Last 7 Days')),
                    ],
                    onChanged: _onFilterChanged,
                    dropdownColor: Colors.white.withOpacity(0.9),
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.6), // Center near the top
            radius: 1.5,
            colors: [
              Color(0xFFBBDEFB), // Light Blue
              Color(0xFF2196F3), // Primary Blue
              Color(0xFF0D47A1), // Dark Blue
            ],
            stops: [0.2, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
          child: ListView.builder(
            itemCount: _filteredNotifications.length,
            itemBuilder: (_, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: NotificationTile(
                  notification: _filteredNotifications[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
