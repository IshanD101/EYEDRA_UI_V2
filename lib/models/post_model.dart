class Post {
  final String username;
  final String content;
  final String imageUrl;
  int likes;
  int dislikes;
  int comments;
  int shares;
  
  Post({
    required this.username,
    required this.content,
    required this.imageUrl,
    this.likes = 0,
    this.dislikes = 0,
    this.comments = 0,
    this.shares = 0,
  });
}
