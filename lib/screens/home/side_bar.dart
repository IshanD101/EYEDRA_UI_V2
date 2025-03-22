import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/screens/listener_registration.dart';  // Import the Listener Registration Page

class SideBar extends StatefulWidget {
  final Function(int) onMenuItemSelected;
  const SideBar({super.key, required this.onMenuItemSelected});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: BackdropFilter(

        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            gradient: LinearGradient(

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[900]!.withOpacity(0.3),
                Colors.black,
              ],
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(

              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(

                color: Colors.blue.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'EYEDRA Menu',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildMenuItem(Icons.info, 'About', 0),
              _buildMenuItem(Icons.lock, 'Privacy Policy', 1),
              _buildMenuItem(Icons.fireplace, 'Campfire', 2),
              _buildMenuItem(Icons.headset_mic, 'Listener', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    final bool isHovered = hoveredIndex == index;

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
          widget.onMenuItemSelected(index);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),  // Changed to white with opacity
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isHovered
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.1),
                    width: isHovered ? 1.5 : 1,
                  ),
                  boxShadow: isHovered
                      ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                      : [],
                ),
                child: ListTile(
                  leading: Icon(
                    icon,
                    color: isHovered
                        ? Colors.blue[900]
                        : Colors.blue[900]?.withOpacity(0.7),
                    size: 24,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: isHovered
                          ? Colors.blue[900]
                          : Colors.blue[900]?.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: isHovered
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

              // Sidebar Header
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.purple, Colors.deepPurple],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: const Text(
//                   'EYEDRA Menu',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               // Sidebar Items
//               _buildMenuItem(Icons.info, 'About', 0, context),
//               _buildMenuItem(Icons.lock, 'Privacy Policy', 1, context),
//               _buildMenuItem(Icons.fireplace, 'Campfire', 2, context),
//               _buildListenerMenuItem(context),  // Updated Listener button
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Generic Menu Item Builder
//   Widget _buildMenuItem(
//       IconData icon, String title, int index, BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white.withOpacity(0.9)),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: Colors.white.withOpacity(0.9),
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       onTap: () {
//         Navigator.pop(context);
//         onMenuItemSelected(index);
//       },
//       tileColor: Colors.transparent,
//       splashColor: Colors.blueAccent.withOpacity(0.3),
// 
    );
  }

  /// Updated "Listener" Button to Open the Registration Page
  Widget _buildListenerMenuItem(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.headset_mic, color: Colors.white.withOpacity(0.9)),
      title: Text(
        "Become a Listener",
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Navigator.pop(context);  // Close Sidebar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListenerRegistrationPage()),
        );
      },
      tileColor: Colors.transparent,
      splashColor: Colors.greenAccent.withOpacity(0.3),
    );
  }
}

/// Function to Display the Sidebar as a Modal Bottom Sheet
void showSideBar(BuildContext context, Function(int) onMenuItemSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Row(
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
        ),
      );
    },
  );
}