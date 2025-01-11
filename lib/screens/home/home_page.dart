import 'package:eyedra_ui_v2/screens/community/group_space.dart';
import 'package:eyedra_ui_v2/screens/feed/feed_main.dart';
import 'package:eyedra_ui_v2/screens/home/notification_page.dart';
import 'package:eyedra_ui_v2/screens/navigation.dart';
import 'package:eyedra_ui_v2/screens/profile/profile_page.dart';
import 'package:eyedra_ui_v2/screens/virtual_campfire/campfire_main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    Center(child: Text('Home')),
    Community(),
    CampfireMain(),
    FeedMain(),
    NotificationPage(),
  ];

  // Titles for each tab
  final List<String> titles = [
    "EYEDRA", // Home
    "COMMUNITY", // Community Tab
    "CAMPFIRE", // Campfire Tab
    "FEED", // Feed Tab
    "NOTIFICATIONS", // Notifications Tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.blue[800]),
            onPressed: () {},
          ),
          centerTitle: true,
          title: Text(
            titles[_currentIndex], // Dynamically setting title from list
            style: const TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontSize: 25,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person, color: Colors.blue[800]),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
