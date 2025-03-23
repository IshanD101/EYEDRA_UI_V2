import 'dart:ui';
import 'package:flutter/material.dart';
import '/models/group_space_model.dart';
import '../../services/app/group_service.dart';
import '/widgets/community_card.dart';
import '/widgets/search_bar.dart';

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  bool _isLoading = false;
  List<CommunityGroup> _communityGroups = [];
  List<CommunityGroup> _filteredGroups = [];
  String userRole = "Normal_user"; // Change to "Listener" or "Admin" to test
  final GroupService _groupService = GroupService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
    });

    final groups = await _groupService.fetchGroups();
    setState(() {
      _communityGroups = groups;
      _filteredGroups = List.from(groups);
      _isLoading = false;
    });
  }

  void _filterGroups(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredGroups = List.from(_communityGroups);
      } else {
        _filteredGroups = _communityGroups
            .where((group) => group.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _createGroup() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create Group"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Group Name")),
              TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _communityGroups.add(CommunityGroup(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    imageUrl: '',
                    description: descController.text.isNotEmpty
                        ? descController.text
                        : "No description available",
                    memberCount: 0,
                  ));
                });
                Navigator.pop(context);
              },
              child: Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteGroup(String groupId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Group"),
        content: Text("Are you sure you want to delete this group?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteGroup(groupId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _deleteGroup(String groupId) {
    setState(() {
      _communityGroups.removeWhere((group) => group.id == groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[900]!.withOpacity(0.6),
      floatingActionButton: (userRole == "Listener" || userRole == "Admin")
          ? FloatingActionButton(
        onPressed: _createGroup,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),

            /// **🔍 Search Bar**
            SearchBarWidget(
              controller: _searchController,
              onChanged: _filterGroups,
            ),

            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_filteredGroups.isEmpty) {
      return Center(child: Text("No groups found", style: TextStyle(color: Colors.white)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _filteredGroups.length,
      itemBuilder: (context, index) {
        CommunityGroup group = _filteredGroups[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CommunityCard(
            groupId: group.id,
            groupName: group.name,
            description: group.description ?? "No description available",
            members: group.memberCount ?? 0,
            canDelete: userRole == "Listener" || userRole == "Admin",
            onDelete: () => _confirmDeleteGroup(group.id),
          ),
        );
      },
    );
  }
}
