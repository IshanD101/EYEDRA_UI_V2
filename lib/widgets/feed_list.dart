import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/models/post_model.dart';
import 'package:eyedra_ui_v2/widgets/posts_widget.dart';

class FeedList extends StatelessWidget {
  final List<Post> posts = [
    Post(
      username: "Ishan",
      content: "Had an amazing day!",
      imageUrl:
          "https://images.unsplash.com/photo-1739993655680-4b7050ed2896?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Sample image
    ),
    Post(
      username: "Chathnindu",
      content: "Just finished a great book",
      imageUrl:
          "https://images.unsplash.com/photo-1740166260070-4d129541aa52?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
    Post(
      username: "Sanjula",
      content: "Loving this community!",
      imageUrl:
          "https://images.unsplash.com/photo-1740166260070-4d129541aa52?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
  ];

  FeedList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostWidget(post: posts[index]);
      },
    );
  }
}
