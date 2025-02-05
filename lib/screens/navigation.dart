import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: "People",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_camera_back_outlined),
          label: "Videos",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_media_outlined),
          label: "Media",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: "Notifications",
        ),
      ],
      backgroundColor: Colors.white,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.blue[800],
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
