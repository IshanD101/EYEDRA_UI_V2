import 'dart:ui';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  final Function(int) onMenuItemSelected;
  const SideBar({super.key, required this.onMenuItemSelected});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin {
  int? hoveredIndex;
  int? selectedIndex;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade900.withOpacity(0.4),
                Colors.indigo.shade900.withOpacity(0.8),
              ],
              stops: const [0.3, 1.0],
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade800.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              // Header
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade900.withOpacity(0.3),
                          Colors.indigo.shade900.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Colors.blue.shade100,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'EYEDRA',
                          style: TextStyle(
                            color: Colors.blue.shade50,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Menu Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'MENU',
                  style: TextStyle(
                    color: Colors.blue.shade100.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildMenuItem(Icons.info_outline, 'About', 0),
              _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', 1),
              _buildMenuItem(Icons.local_fire_department_outlined, 'Campfire', 2),
              _buildMenuItem(Icons.headset_mic_outlined, 'Listener', 3),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Divider(
                  color: Colors.white.withOpacity(0.1),
                  thickness: 1,
                ),
              ),

              // Additional options
              _buildMenuItem(Icons.settings_outlined, 'Settings', 4),
              _buildMenuItem(Icons.help_outline, 'Help Center', 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    final bool isHovered = hoveredIndex == index;
    final bool isSelected = selectedIndex == index;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredIndex = null;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          widget.onMenuItemSelected(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.shade800.withOpacity(0.3)
                : isHovered
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Colors.blue.shade400.withOpacity(0.5)
                  : isHovered
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: isHovered || isSelected
                ? [
              BoxShadow(
                color: Colors.blue.shade900.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
                : [],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: Icon(
              icon,
              color: isSelected
                  ? Colors.blue.shade300
                  : isHovered
                  ? Colors.blue.shade100
                  : Colors.blue.shade100.withOpacity(0.7),
              size: 22,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.blue.shade300
                    : isHovered
                    ? Colors.blue.shade100
                    : Colors.blue.shade100.withOpacity(0.7),
                fontSize: 16,
                fontWeight: isSelected || isHovered
                    ? FontWeight.w600
                    : FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
            trailing: isSelected
                ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                shape: BoxShape.circle,
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }
}

void showSideBar(BuildContext context, Function(int) onMenuItemSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context).overlay!,
      duration: const Duration(milliseconds: 300),
    ),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Row(
            children: [
              SideBar(onMenuItemSelected: (index) {
                onMenuItemSelected(index);
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.pop(context);
                });
              }),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}