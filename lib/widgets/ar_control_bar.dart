import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AR World button with colorful text in the center
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCenterLaunchButton(),
                const SizedBox(width: 12),
                _buildColorfulText("AR WORLD"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorfulText(String text) {
    // Define colors for each letter
    final List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(text.length, (index) {
        return Text(
          text[index],
          style: TextStyle(
            color: colors[index % colors.length],
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: colors[index % colors.length].withOpacity(0.7),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCenterLaunchButton() {
    return Container(
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulse animation would go here with AnimatedBuilder
            Icon(
              Icons.view_in_ar,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}