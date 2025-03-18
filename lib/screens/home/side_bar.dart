import 'dart:ui';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final Function(int) onMenuItemSelected;

  const SideBar({super.key, required this.onMenuItemSelected});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Updated blur effect
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.4)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.15), // Subtle border
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Text(
                  'EYEDRA Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildMenuItem(Icons.info, 'About', 0, context),
              _buildMenuItem(Icons.lock, 'Privacy Policy', 1, context),
              _buildMenuItem(Icons.fireplace, 'Campfire', 2, context),
              _buildMenuItem(Icons.headset_mic, 'Listener', 3, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, int index, BuildContext context) {
    return ListTile(
      leading:
          Icon(icon, color: Colors.white.withOpacity(0.9)), // Darker icon color
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9), // Darker text color
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Navigator.pop(context);
        onMenuItemSelected(index);
      },
      tileColor: Colors.transparent,
      splashColor: Colors.blueAccent.withOpacity(0.3),
    );
  }
}

void showSideBar(BuildContext context, Function(int) onMenuItemSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Row(
        children: [
          SideBar(onMenuItemSelected: onMenuItemSelected),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      );
    },
  );
}
