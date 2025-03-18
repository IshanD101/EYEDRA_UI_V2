import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/screens/community/group_space.dart';
import 'package:eyedra_ui_v2/screens/feed/feed_main.dart';
import 'package:eyedra_ui_v2/screens/home/notification_page.dart';
import 'package:eyedra_ui_v2/screens/home/side_bar.dart';
import 'package:eyedra_ui_v2/screens/navigation.dart';
import 'package:eyedra_ui_v2/screens/profile/profile_page.dart';
import 'package:eyedra_ui_v2/screens/virtual_campfire/campfire_main.dart';
import 'package:eyedra_ui_v2/widgets/feed_list.dart';
import 'package:eyedra_ui_v2/widgets/status_bar.dart'; // Import the new StatusBar widget
import 'AppBar.dart'; // Import the custom AppBar

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  final List<Widget> pages = [
    FeedList(),
    Community(),
    CampfireMain(),
    FeedMain(),
    NotificationPage(),
  ];

  final List<String> titles = [
    "EYEDRA",
    "COMMUNITY",
    "CAMPFIRE",
    "FEED",
    "NOTIFICATIONS",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Use the custom glassmorphic app bar
      appBar: CustomAppBar.buildGlassmorphicAppBar(
        context,
        _scaffoldKey,
        titles[_currentIndex],
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
      ),
      drawer: Drawer(
        child: SideBar(
          onMenuItemSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar that only appears on the feed page (index 0)
            if (_currentIndex == 0)
              const StatusBar(),
            // Expanded to make the page fill the remaining space
            Expanded(
              child: pages[_currentIndex], // Displays the selected page
            ),
          ],
        ),
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