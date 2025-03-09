import 'package:flutter/material.dart';
import '../models/group_space_model.dart';
import 'community_card.dart';

class GroupGrid extends StatelessWidget {
  final List<CommunityGroup> groups;
  final String searchQuery;

  const GroupGrid({
    Key? key,
    required this.groups,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.white.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              searchQuery.isEmpty
                  ? 'No communities found'
                  : 'No communities match "$searchQuery"',
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
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return CommunityCard(group: group);
        },
      ),
    );
  }
}