import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'dart:ui';

class CustomGlassmorphicNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomGlassmorphicNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
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
                currentIndex: selectedIndex,
                onTap: onItemTapped,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.blue[300],
                unselectedItemColor: Colors.white.withOpacity(0.9),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                items: _buildNavItems(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return [
      _buildNavItem(
        0,
        'assets/icons/home-simple-door.svg',
        'Homepage',
      ),
      _buildNavItem(
        1,
        'assets/icons/group.svg',
        'Community',
      ),
      _buildSpecialNavItem(
        2,
        'assets/icons/fire-wood.svg',
        'assets/icons/campfire.riv',
        'Campfire Sessions',
      ),
      _buildNavItem(
        3,
        'assets/icons/posts-carousel-vertical.svg',
        'Reels',
      ),
      _buildNavItem(
        4,
        'assets/icons/profile-default.svg',
        'Profile',
      ),
    ];
  }

  BottomNavigationBarItem _buildNavItem(
      int index, String iconPath, String label) {
    bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: SvgPicture.asset(
          iconPath,
          color: isSelected ? Colors.blue[300] : Colors.white.withOpacity(0.9),
          height: 24,
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildSpecialNavItem(
      int index, String iconPath, String rivePath, String label) {
    bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? SizedBox(
                height: 28,
                width: 32,
                child: RiveAnimation.asset(
                  rivePath,
                  fit: BoxFit.contain,
                ),
              )
            : SvgPicture.asset(
                iconPath,
                color: Colors.white.withOpacity(0.9),
                height: 24,
              ),
      ),
      label: label,
    );
  }
}
