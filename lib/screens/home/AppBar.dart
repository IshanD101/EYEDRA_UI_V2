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
              child: Container(), // Will add row content later
            ),
          ),
        ),
      ),
    );
  }
}
