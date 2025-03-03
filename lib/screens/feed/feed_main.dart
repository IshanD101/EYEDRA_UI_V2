import 'package:eyedra_ui_v2/models/post_model.dart';
import 'package:flutter/material.dart';

final List<Post> dummyPosts = [
Post(username: "user1", content: "Post 1", imageUrl: "https://picsum.photos/id/237/200/300"),
Post(username: "user2", content: "Post 2", imageUrl: "https://picsum.photos/id/238/200/300"),
Post(username: "user3", content: "Post 3", imageUrl: "https://picsum.photos/id/239/200/300"),
Post(username: "user4", content: "Post 4", imageUrl: "https://picsum.photos/id/240/200/300"),
Post(username: "user5", content: "Post 5", imageUrl: "https://picsum.photos/id/241/200/300"),
Post(username: "user6", content: "Post 6", imageUrl: "https://picsum.photos/id/242/200/300"),
Post(username: "user7", content: "Post 7", imageUrl: "https://picsum.photos/id/243/200/300"),
Post(username: "user8", content: "Post 8", imageUrl: "https://picsum.photos/id/244/200/300"),
Post(username: "user9", content: "Post 9", imageUrl: "https://picsum.photos/id/245/200/300"),
Post(username: "user10", content: "Post 10", imageUrl: "https://picsum.photos/id/246/200/300"),
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