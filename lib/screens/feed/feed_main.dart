import 'package:eyedra_ui_v2/models/post_model.dart';
import 'package:flutter/material.dart';

final List<Post> dummyPosts = [
  Post(username: "user1", content: "Post 1", imageUrl: "https://picsum.photos/id/237/200/300"),
  Post(username: "user2", content: "Post 2", imageUrl: "https://picsum.photos/id/238/200/300"),
];

class FeedMain extends StatefulWidget {
  const FeedMain({super.key});

  @override
  State<FeedMain> createState() => _FeedState();
}

class _FeedState extends State<FeedMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}