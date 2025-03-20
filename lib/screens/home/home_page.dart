import 'package:eyedra_ui_v2/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/screens/community/group_space.dart';
import 'package:eyedra_ui_v2/screens/feed/feed_main.dart';
import 'package:eyedra_ui_v2/screens/home/notification_page.dart';
import 'package:eyedra_ui_v2/screens/home/side_bar.dart';
import 'package:eyedra_ui_v2/screens/profile/profile_page.dart';
import 'package:eyedra_ui_v2/screens/virtual_campfire/campfire_main.dart';
import 'package:eyedra_ui_v2/widgets/feed_list.dart';
import 'package:eyedra_ui_v2/widgets/status_bar.dart';
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
                      if (_currentIndex == 0) const StatusBar(),
                      Expanded(
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
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CustomGlassmorphicNavBar(
                    selectedIndex: _currentIndex,
                    onItemTapped: (int newIndex) {
                      setState(() {
                        _currentIndex = newIndex;
                      });
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