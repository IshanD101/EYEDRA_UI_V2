import 'package:eyedra_ui_v2/models/post_model.dart';
import 'package:flutter/material.dart';

class FeedMain extends StatefulWidget {
  const FeedMain({super.key});

  @override
  State<FeedMain> createState() => _FeedState();
}

class _FeedState extends State<FeedMain> {
  final List<Post> _posts = [
    Post(
      username: "user1",
      content: "Enjoying a sunny day at the beach!",
      imageUrl: "https://picsum.photos/500/300?random=1",
      likes: 120,
      comments: 15,
      shares: 5,
    ),
    Post(
      username: "user2",
      content: "Delicious homemade pizza tonight.",
      imageUrl: "https://picsum.photos/500/300?random=2",
      likes: 85,
      dislikes: 3,
      comments: 10,
      shares: 2,
    ),
    Post(
      username: "user3",
      content: "Exploring the mountains this weekend!",
      imageUrl: "https://picsum.photos/500/300?random=3",
      likes: 200,
      comments: 25,
      shares: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Feed'),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 300,
                child: Center(child: Text('Image failed to load')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Text(post.content),
          ),
        ],
      ),
    );
  }
}