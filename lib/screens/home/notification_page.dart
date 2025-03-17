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
        backgroundColor: Colors.grey[900]?.withOpacity(0.7),
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
                        'Hello, User!',
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedFilter,
                              icon: Icon(Icons.filter_alt_outlined, color: Colors.blue[400]),
                              underline: Container(),
                              dropdownColor: Colors.grey[900]?.withOpacity(0.9),
                              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              onChanged: _onFilterChanged,
                              items: [
                                DropdownMenuItem(
                                  value: 'All',
                                  child: Text(
                                    'All',
                                    style: TextStyle(
                                      color: Colors.white, // Set white text
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Today',
                                  child: Text(
                                    'Today',
                                    style: TextStyle(
                                      color: Colors.white, // Set white text
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Yesterday',
                                  child: Text(
                                    'Yesterday',
                                    style: TextStyle(
                                      color: Colors.white, // Set white text
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Last 7 Days',
                                  child: Text(
                                    'Last 7 Days',
                                    style: TextStyle(
                                      color: Colors.white, // Set white text
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[900]!.withOpacity(0.3),
                  Colors.black,
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: ListView.builder(
                itemCount: _filteredNotifications.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              _filteredNotifications[index].title,
                              style: TextStyle(
                                color: Colors.white, // <-- Ensure white text
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _filteredNotifications[index].timestamp.toString(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7), // Subtitle text
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