import 'package:eyedra_ui_v2/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/utils/notification_util.dart';
import 'package:eyedra_ui_v2/models/user_notifications.dart';
import 'dart:ui';

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
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  'Hello, User!',
                  style: textTheme.titleLarge?.copyWith(color: Colors.black),
                ),
                // Date Filter Dropdown
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
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
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    underline: SizedBox(),
                  ),
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
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4), // Darker background
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15), // Subtle border
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.15),
                        blurRadius: 25,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12), // Added padding
                  child: NotificationTile(
                    notification: _filteredNotifications[index],
                  ),
                ),
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
