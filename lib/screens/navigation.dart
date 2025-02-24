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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 28),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline, size: 28),
                label: "People",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_camera_back_outlined, size: 28),
                label: "Videos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_media_outlined, size: 28),
                label: "Media",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined, size: 28),
                label: "Notifications",
              ),
            ],
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.blue[800],
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
