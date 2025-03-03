import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/models/post_model.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info section
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  widget.post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Post content
            Text(widget.post.content),

            const SizedBox(height: 10),

            // Post Image Section
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.post.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            // Like, Dislike, Comment, and Share Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(Icons.thumb_up, widget.post.likes, Colors.blue,
                        () {
                      setState(() => widget.post.likes++);
                    }),
                _buildIconButton(
                    Icons.thumb_down, widget.post.dislikes, Colors.red, () {
                  setState(() => widget.post.dislikes++);
                }),
                _buildIconButton(
                    Icons.comment, widget.post.comments, Colors.grey, () {
                  setState(() => widget.post.comments++);
                }),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.green),
                  onPressed: () {
                    setState(() => widget.post.shares++);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, int count, Color color, VoidCallback onPressed) {
    return Row(
      children: [
        IconButton(icon: Icon(icon, color: color), onPressed: onPressed),
        Text(count.toString()),
      ],
    );
  }
}
