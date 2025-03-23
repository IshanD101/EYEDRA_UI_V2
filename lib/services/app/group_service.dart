import '/models/group_space_model.dart';
import '../api/api_service.dart';

class GroupService {
  final ApiService _apiService = ApiService();

  // Fetch all groups
  Future<List<CommunityGroup>> fetchGroups() async {
    try {
      final response = await _apiService.get('groups');
      final groups = (response['data'] as List)
          .map((json) => CommunityGroup(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'] ?? '',
        description: json['description'],
        memberCount: json['memberCount'] ?? 0,
      ))
          .toList();
      return groups;
    } catch (e) {
      print('Error fetching groups: $e');
      return [];
    }
  }

  // Create a new group
  Future<CommunityGroup?> createGroup(String name, String description) async {
    try {
      final response = await _apiService.post('groups', {
        'name': name,
        'description': description,
      });

      return CommunityGroup(
        id: response['id'],
        name: response['name'],
        imageUrl: response['imageUrl'] ?? '',
        description: response['description'],
        memberCount: 0,
      );
    } catch (e) {
      print('Error creating group: $e');
      return null;
    }
  }

  // Delete a group
  Future<bool> deleteGroup(String groupId) async {
    try {
      await _apiService.delete('groups/$groupId');
      return true;
    } catch (e) {
      print('Error deleting group: $e');
      return false;
    }
  }

  // Get group details
  Future<CommunityGroup?> getGroupDetails(String groupId) async {
    try {
      final response = await _apiService.get('groups/$groupId');

      return CommunityGroup(
        id: response['id'],
        name: response['name'],
        imageUrl: response['imageUrl'] ?? '',
        description: response['description'],
        memberCount: response['memberCount'] ?? 0,
      );
    } catch (e) {
      print('Error getting group details: $e');
      return null;
    }
  }

  Future<List<CommunityGroup>> updateExistingGroups() async {
    return await fetchGroups();
  }
}