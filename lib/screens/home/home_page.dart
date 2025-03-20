import 'package:eyedra_ui_v2/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/screens/community/group_space.dart';
import 'package:eyedra_ui_v2/screens/feed/feed_main.dart';
import 'package:eyedra_ui_v2/screens/home/notification_page.dart';
import 'package:eyedra_ui_v2/screens/home/side_bar.dart';
import 'package:eyedra_ui_v2/screens/profile/profile_page.dart';
import 'package:eyedra_ui_v2/screens/virtual_campfire/campfire_main.dart';
import 'package:eyedra_ui_v2/widgets/feed_list.dart';
import 'package:eyedra_ui_v2/widgets/ar_control_bar.dart'; // Import the StatusBar widget
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
    ProfilePage(),
  ];

  final List<String> titles = [
    "EYEDRA",
    "COMMUNITY",
    "CAMPFIRE",
    "FEED",
    "PROFILE",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                if (_currentIndex == 0)
                  const ARControlBar(), // StatusBar only on feed page
                Expanded(
                  child: pages[_currentIndex], // Display selected page
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomGlassmorphicNavBar(
              selectedIndex: _currentIndex,
              onItemTapped: (int newIndex) {
                setState(() {
                  _currentIndex = newIndex;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
