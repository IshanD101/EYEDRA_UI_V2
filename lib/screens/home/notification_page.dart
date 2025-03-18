import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:eyedra_ui_v2/widgets/notification_tile.dart';
import 'package:eyedra_ui_v2/utils/notification_util.dart';
import 'package:eyedra_ui_v2/models/user_notifications.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}
//Notification Page using StatefulWidget
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
    super.build(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.grey[900]?.withOpacity(0.8),
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hello, User! 👋',
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          shadows: [
                            Shadow(
                              color: Colors.blue.withOpacity(0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            icon: Icon(Icons.filter_alt_outlined, color: Colors.blue[400]),
                            dropdownColor: Colors.grey[900]?.withOpacity(0.9),
                            style: const TextStyle(color: Colors.white),
                            onChanged: _onFilterChanged,
                            items: ['All', 'Today', 'Yesterday', 'Last 7 Days']
                                .map(
                                  (filter) => DropdownMenuItem(
                                value: filter,
                                child: Text(
                                  filter,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[900]!.withOpacity(0.4),
                  Colors.black,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _filteredNotifications.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.15),
                                blurRadius: 12,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.3),
                              child: Icon(
                                Icons.notifications,
                                color: Colors.blue[300],
                              ),
                            ),
                            title: Text(
                              _filteredNotifications[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              _filteredNotifications[index].timestamp.toString(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}