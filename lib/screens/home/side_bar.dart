import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final Function(int) onMenuItemSelected;

  const SideBar({Key? key, required this.onMenuItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5, // Half the screen width
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blueAccent,
            child: const Text(
              'EYEDRA Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.arrow_forward_ios),
            title: const Text('About'),
            onTap: () {
              // onMenuItemSelected(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_forward_ios),
            title: const Text('Privacy Policy'),
            onTap: () {
              // onMenuItemSelected(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_forward_ios),
            title: const Text('Campfire'),
            onTap: () {
              // onMenuItemSelected(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_forward_ios),
            title: const Text('Listener'),
            onTap: () {
              // onMenuItemSelected(3);
              Navigator.pop(context);
            },
          ),
        ],
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
