import 'package:flutter/material.dart';
import '../../models/community_space_model.dart';

class Community extends StatefulWidget {
  const Community({super.key});

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
    _fetchCommunityGroups();
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
            .where((group) =>
                group.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _fetchCommunityGroups() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      final List<Map<String, dynamic>> sampleData = [
        {
          'id': '1',
          'name': 'Peaceful Yoga',
          'imageUrl': 'https://example.com/photo.jpg',
          'description': 'A community for photography enthusiasts',
          'memberCount': 150,
          'createdAt': '2024-02-24T10:00:00Z',
        },
        {
          'id': '2',
          'name': 'Book Readers',
          'imageUrl': 'https://example.com/books.jpg',
          'description': 'Share your favorite books and discuss',
          'memberCount': 200,
          'createdAt': '2024-02-23T15:30:00Z',
        },
      ];

      final groups =
          sampleData.map((json) => CommunityGroup.fromJson(json)).toList();

      setState(() {
        _communityGroups = groups;
        _filteredGroups = List.from(groups);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load community groups';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterGroups,
            decoration: InputDecoration(
              hintText: 'Search communities...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _filterGroups('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchCommunityGroups,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement create community functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchCommunityGroups,
              child: const Text('Retry'),
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
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No communities found'
                  : 'No communities match your search',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCommunityGroups,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            return CommunityCard(
              groupName: group.name,
              imageUrl: group.imageUrl,
              memberCount: group.memberCount,
              onTap: () {
                // TODO: Navigate to group chat
                print('Tapped on ${group.name}');
              },
            );
          },
        ),
      ),
    );
  }
}

// CommunityCard widget remains the same
class CommunityCard extends StatelessWidget {
  final String groupName;
  final String imageUrl;
  final int? memberCount;
  final VoidCallback onTap;

  const CommunityCard({
    super.key,
    required this.groupName,
    required this.imageUrl,
    this.memberCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.group,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  if (memberCount != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$memberCount members',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
