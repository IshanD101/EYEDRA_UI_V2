import 'package:eyedra_ui_v2/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/screens/community/group_space.dart';
import 'package:eyedra_ui_v2/screens/feed/feed_main.dart';
import 'package:eyedra_ui_v2/screens/home/notification_page.dart';
import 'package:eyedra_ui_v2/screens/home/side_bar.dart';
import 'package:eyedra_ui_v2/screens/profile/profile_page.dart';
import 'package:eyedra_ui_v2/screens/virtual_campfire/campfire_main.dart';
import 'package:eyedra_ui_v2/widgets/feed_list.dart';
import 'package:eyedra_ui_v2/widgets/ar_control_bar.dart';
import 'AppBar.dart';
import 'dart:ui';

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

  // Modified: Removed ProfilePage from the direct pages list
  final List<Widget> pages = [
    FeedList(),
    Community(),
    CampfireMain(),
    FeedMain(),
    Container(), // Empty container as placeholder for Profile
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
      // Add a Container with background color that wraps the AppBar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.grey[900]!.withOpacity(0.6), // Background color for the AppBar
          child: CustomAppBar.buildGlassmorphicAppBar(
            context,
            _scaffoldKey,
            titles[_currentIndex],
                () {
              // Navigate to profile as a new screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.grey[900]!.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      if (_currentIndex == 0) const ARControlBar(),
                      Expanded(
                        // Only show the current page if it's not the profile page
                        child: pages[_currentIndex],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900]!.withOpacity(0.6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CustomGlassmorphicNavBar(
                    selectedIndex: _currentIndex,
                    onItemTapped: (int newIndex) {
                      // Modified: Handle profile navigation separately
                      if (newIndex == 4) {
                        // Profile tab - open as a new window
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      } else {
                        // Other tabs - switch tabs as normal
                        setState(() {
                          _currentIndex = newIndex;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}