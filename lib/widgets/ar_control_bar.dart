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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // AR World button


            // AR Experience Launch button (center, larger)
            _buildCenterLaunchButton(),

            // AR Effects Gallery

          ],
        ),
      ),
    );
  }

  Widget _buildARControlButton({
    required IconData icon,
    required String label,
    required Color glowColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: GlassmorphicContainer(
            width: 42,
            height: 42,
            borderRadius: 42,
            blur: 5,
            alignment: Alignment.center,
            border: 1.5,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
              stops: const [0.1, 1],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                glowColor.withOpacity(0.6),
                Colors.white.withOpacity(0.5),
                glowColor.withOpacity(0.6),
              ],
              stops: const [0.1, 0.5, 0.9],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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