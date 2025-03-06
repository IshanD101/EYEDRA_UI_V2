import 'package:eyedra_ui_v2/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController(text: "User user");
  TextEditingController bioController = TextEditingController(text: "User is a Software Engineering student at IIT, affiliated with the University of Westminster.");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "User user",
            style: TextStyle(color: Colors.blue[900]),
          ),
          backgroundColor: Colors.grey[900],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.blue[800]),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.blue[800]),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person, size: 50, color: Colors.grey),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _editProfileWindow(context),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.blue[600],
                              child: Icon(Icons.edit, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nameController.text,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bioController.text,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Followers", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.blue[600], size: 36),
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            TabBar(
              indicatorColor: Colors.purple,
              labelColor: Colors.blue[800],
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.grid_view_outlined)),
                Tab(icon: Icon(Icons.list_alt_outlined)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildGridView(),
                  _buildListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _popupWindow(context, "Details about item $index go here..."),
          child: Container(
            color: Colors.grey[700],
            child: Center(
              child: Text("Item $index", style: const TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.grey[800],
          margin: const EdgeInsets.only(bottom: 12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Post $index", style: const TextStyle(fontSize: 16, color: Colors.white)),
          ),
        );
      },
    );
  }

  void _popupWindow(BuildContext context, String details) {
    // Define the popup window logic here.
  }

  void _editProfileWindow(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: "Bio"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
