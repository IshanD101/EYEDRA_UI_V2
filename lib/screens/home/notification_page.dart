import 'package:eyedra_ui_v2/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/utils/notification_util.dart';
import 'package:eyedra_ui_v2/models/user_notifications.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

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
    super.build(context); // Call to super.build(context)
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello, User!',
                  style: textTheme.titleLarge?.copyWith(color: Colors.black),
                ),
                // Date Filter Dropdown
                DropdownButton<String>(
                  value: _selectedFilter,
                  icon: Icon(Icons.filter_alt_outlined, color: Colors.black),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Today', child: Text('Today')),
                    DropdownMenuItem(
                        value: 'Yesterday', child: Text('Yesterday')),
                    DropdownMenuItem(
                        value: 'Last 7 Days', child: Text('Last 7 Days')),
                  ],
                  onChanged: _onFilterChanged,
                  dropdownColor: const Color.fromARGB(255, 248, 247, 247),
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _filteredNotifications.length,
          itemBuilder: (_, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 5,
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
