import 'dart:ui';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  final Function(int) onMenuItemSelected;
  const SideBar({super.key, required this.onMenuItemSelected});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int? hoveredIndex;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[800]!.withOpacity(0.4),
                Colors.indigo[900]!.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 3,
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
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
                          Colors.white.withOpacity(0.15),
                          Colors.blue[900]!.withOpacity(0.4),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EYEDRA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.blue.withOpacity(0.7),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Menu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuItem(Icons.info_outline, 'About', 0),
              _buildMenuItem(Icons.lock_outline, 'Privacy Policy', 1),
              _buildMenuItem(Icons.local_fire_department_outlined, 'Campfire', 2),
              _buildMenuItem(Icons.headset_mic_outlined, 'Listener', 3),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : isHovered
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withOpacity(0.4)
                        : isHovered
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    width: isSelected || isHovered ? 1.5 : 1,
                  ),
                  boxShadow: isSelected || isHovered
                      ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                      : [],
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withOpacity(0.3)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected || isHovered
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: isSelected || isHovered
                          ? Colors.white
                          : Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : isHovered
                          ? FontWeight.w600
                          : FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  trailing: isSelected
                      ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),
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
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [
              SideBar(onMenuItemSelected: (index) {
                onMenuItemSelected(index);
                // Optional: close the sidebar after selection
                Future.delayed(const Duration(milliseconds: 200), () {
                  Navigator.pop(context);
                });
              }),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
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