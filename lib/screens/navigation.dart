import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    double horizontalPadding = MediaQuery.of(context).size.width * 0.05;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                HapticFeedback.lightImpact(); // Add haptic feedback
                onItemTapped(index);
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor:
                  Theme.of(context).primaryColor, // Use theme color
              unselectedItemColor: Colors.grey,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/home-simple-door.svg',
                    color: selectedIndex == 0
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    height: 24,
                  ),
                  label: "Homepage",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/group.svg',
                    color: selectedIndex == 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    height: 28,
                  ),
                  label: "Community",
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    height: 28,
                    width: 32,
                    child: selectedIndex == 2
                        ? RiveAnimation.asset(
                            'assets/icons/campfire.riv',
                            fit: BoxFit.contain,
                          )
                        : SvgPicture.asset(
                            'assets/icons/fire-wood.svg',
                            color: Colors.grey,
                            height: 24,
                          ),
                  ),
                  label: "Campfire Sessions",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/posts-carousel-vertical.svg',
                    color: selectedIndex == 3
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    height: 24,
                  ),
                  label: "Reels",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/profile-default.svg',
                    color: selectedIndex == 4
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    height: 24,
                  ),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
