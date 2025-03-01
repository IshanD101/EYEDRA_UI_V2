import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:eyedra_ui_v2/screens/EyedraBot/chatbot.dart';

class CustomAppBar {
  static PreferredSizeWidget buildGlassmorphicAppBar(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey,
      String title,
      VoidCallback onProfileTap) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        margin: const EdgeInsets.only(top: 40, left: 16, right: 16),
        height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                  children: [
              IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            Expanded(
              child: Center(
                child: _buildColorfulText(title),
              ),
            ),
            ],
              ),// Will add row content later
            ),
          ),
        ),
      ),
    );
  }
  static Widget _buildColorfulText(String text) {
    final colors = [
      const Color(0xFF74A3FF),
      const Color(0xFF73C5FE),
      const Color(0xFF73B7FE),
      const Color(0xFF74A3FF),
      const Color(0xFF7396FE),
      const Color(0xFF7490FE),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < text.length; i++)
          Text(
            text[i],
            style: TextStyle(
              color: i < colors.length ? colors[i] : colors[i % colors.length],
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
      ],
    );
  }
}
