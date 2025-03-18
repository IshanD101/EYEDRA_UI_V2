import '../models/group_space_model.dart';

class GroupService {
  Future<List<CommunityGroup>> fetchGroups() async {
    // Mock data for front-end demo
    await Future.delayed(const Duration(milliseconds: 800));

    return [
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
  }
}
