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
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.purple,
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
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, int index, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade900),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.blue.shade900,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Navigator.pop(context);
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