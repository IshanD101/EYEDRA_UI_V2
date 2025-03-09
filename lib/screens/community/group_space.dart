import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
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
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Community Space',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: _filterGroups,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search communities...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.blueGrey.shade800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
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
            ElevatedButton(
              onPressed: _loadGroups,
              child: const Text('Try Again'),
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
            const Icon(Icons.search_off, size: 60, color: Colors.white54),
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
      child: GlassmorphicContainer(
        width: 150,
        height: 180,
        borderRadius: 20,
        blur: 15,
        border: 2,
        linearGradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.1)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                group.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            if (group.memberCount != null)
              Text(
                '${group.memberCount} members',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}