import 'package:flutter/material.dart';
import 'dart:ui';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Updated blur effect
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4), // Darker background
              borderRadius: BorderRadius.circular(25),
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
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              items: _buildNavItems(),
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.blue[300], // Darker selected item color
              unselectedItemColor:
                  Colors.white.withOpacity(0.9), // Darker unselected item color
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return [
      _buildNavItem(Icons.home_outlined, Icons.home, "Home"),
      _buildNavItem(Icons.people_outline, Icons.people, "People"),
      _buildNavItem(
          Icons.video_camera_back_outlined, Icons.video_camera_back, "Videos"),
      _buildNavItem(Icons.perm_media_outlined, Icons.perm_media, "Media"),
      _buildNavItem(
          Icons.notifications_outlined, Icons.notifications, "Notifications"),
    ];
  }

  BottomNavigationBarItem _buildNavItem(
      IconData outlinedIcon, IconData filledIcon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: currentIndex == _getIndexFromLabel(label)
              ? Colors.blue.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: currentIndex == _getIndexFromLabel(label)
              ? Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                )
              : null,
          boxShadow: currentIndex == _getIndexFromLabel(label)
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          currentIndex == _getIndexFromLabel(label) ? filledIcon : outlinedIcon,
          size: 24,
          color: Colors.white.withOpacity(0.9), // Darker icon color
        ),
      ),
      label: label,
    );
  }

  int _getIndexFromLabel(String label) {
    switch (label) {
      case "Home":
        return 0;
      case "People":
        return 1;
      case "Videos":
        return 2;
      case "Media":
        return 3;
      case "Notifications":
        return 4;
      default:
        return 0;
    }
  }
}
