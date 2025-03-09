import 'package:flutter/material.dart';
import 'dart:ui';
import 'group_chat_screen.dart';

// Simplified model class to avoid import issues
class CommunityGroup {
  final String id;
  final String name;
  final String imageUrl;
  final String? description;
  final int? memberCount;

  CommunityGroup({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    this.memberCount,
  });
}

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  bool _isLoading = false;
  String? _error;
  List<CommunityGroup> _communityGroups = [];
  List<CommunityGroup> _filteredGroups = [];
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

  void _loadGroups() {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Mock data for front-end demo
    Future.delayed(const Duration(milliseconds: 800), () {
      final groups = [
        CommunityGroup(
          id: '1',
          name: 'Peaceful Yoga',
          imageUrl: '',
          description: 'A relaxing community for yoga lovers',
          memberCount: 150,
        ),
        CommunityGroup(
          id: '2',
          name: 'Book Readers',
          imageUrl: '',
          description: 'Discuss and share your favorite books!',
          memberCount: 200,
        ),
        CommunityGroup(
          id: '3',
          name: 'Fitness Club',
          imageUrl: '',
          description: 'Workout tips and motivation',
          memberCount: 320,
        ),
        CommunityGroup(
          id: '4',
          name: 'Food Club',
          imageUrl: '',
          description: 'All things technology and gadgets',
          memberCount: 175,
        ),
      ];

      if (mounted) {
        setState(() {
          _communityGroups = groups;
          _filteredGroups = List.from(groups);
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900]?.withOpacity(0.7),
        title: const Text(
          'Community Space',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[900]!.withOpacity(0.3),
                  Colors.black,
                ],
              ),
            ),
          ),
          // Content
          Column(
            children: [
              SizedBox(height: AppBar().preferredSize.height + 20),
              _buildSearchBar(),
              Expanded(child: _buildBody()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterGroups,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search communities...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _loadGroups,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Try Again'),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.white.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No communities found'
                  : 'No communities match "${_searchController.text}"',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: _filteredGroups.length,
        itemBuilder: (context, index) {
          final group = _filteredGroups[index];
          return CommunityCard(group: group);
        },
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
  final CommunityGroup group;

  const CommunityCard({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatScreen(
              groupId: group.id,
              groupName: group.name,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 150,
            height: 180,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.0),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.group,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  group.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                if (group.memberCount != null)
                  Text(
                    '${group.memberCount} members',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                if (group.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      group.description!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}