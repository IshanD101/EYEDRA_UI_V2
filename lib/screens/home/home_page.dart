import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/screens/community/group_space.dart';
import 'package:eyedra_ui_v2/screens/feed/feed_main.dart';
import 'package:eyedra_ui_v2/screens/home/notification_page.dart';
import 'package:eyedra_ui_v2/screens/home/side_bar.dart';
import 'package:eyedra_ui_v2/screens/navigation.dart';
import 'package:eyedra_ui_v2/screens/profile/profile_page.dart';
import 'package:eyedra_ui_v2/screens/virtual_campfire/campfire_main.dart';
import 'package:eyedra_ui_v2/widgets/feed_list.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 4,
        shadowColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.blue[800]),
          splashRadius: 25,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          titles[_currentIndex],
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            fontFamily: 'Roboto',
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.blue[800]),
            splashRadius: 25,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
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
        child: pages[_currentIndex], // Displays the selected page
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
