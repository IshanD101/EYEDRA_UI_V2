import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../AR/home_screen_AR.dart';

class ARControlBar extends StatelessWidget {
  const ARControlBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 70,
        borderRadius: 25,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.2),
            Colors.blue.withOpacity(0.2),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.5),
            Colors.blue.withOpacity(0.5),
            Colors.cyan.withOpacity(0.5),
          ],
          stops: const [0.1, 0.5, 0.9],
        ),
        // Simple centered button - no text elements
        child: Center(
          child: _buildCenterLaunchButton(context),
        ),
      ),
    );
  }

  Widget _buildCenterLaunchButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to your individual project's HomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.8),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        child: GlassmorphicContainer(
          width: 60,
          height: 60,
          borderRadius: 60,
          blur: 15,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.3),
              Colors.purple.withOpacity(0.3),
            ],
            stops: const [0.1, 1],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.8),
              Colors.cyan.withOpacity(0.8),
              Colors.purple.withOpacity(0.8),
            ],
            stops: const [0.1, 0.5, 0.9],
          ),
          child: const Icon(
            Icons.view_in_ar,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}