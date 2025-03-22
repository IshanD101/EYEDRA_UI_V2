import 'package:flutter/material.dart';
import 'package:eyedra_ui_v2/models/post_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'dart:ui';

class PostWidget extends StatefulWidget {
  final Post post;
  final Function(Post post)? onLikePressed;

  const PostWidget({
    super.key,
    required this.post,
    this.onLikePressed,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[700]!.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.post.content,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                if (widget.post.imageUrl.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.post.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.white54, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInteractionButton(
                      icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                      label: "${widget.post.likes} Likes",
                      color: _isLiked ? Colors.red : Colors.red.withOpacity(0.8),
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                          if (widget.onLikePressed != null) {
                            widget.onLikePressed!(widget.post);
                          }
                        });
                      },
                      semanticLabel: 'Like post',
                    ),
                    _buildInteractionButton(
                      icon: _isSharing ? Icons.hourglass_empty : Icons.share_outlined,
                      label: _isSharing ? "Sharing..." : "Share",
                      color: Colors.green.withOpacity(0.8),
                      onPressed: _isSharing ? null : _sharePost,
                      semanticLabel: 'Share post',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
    required String semanticLabel,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Semantics(
          label: semanticLabel,
          button: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sharePost() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      // Prepare sharing content
      String shareContent = "${widget.post.username}: ${widget.post.content}";

      // Add image URL if present
      if (widget.post.imageUrl.isNotEmpty) {
        shareContent += "\n\nImage: ${widget.post.imageUrl}";
      }

      // Add app signature
      shareContent += "\n\nShared from Eyedra App!";

      // Show sharing options using URL launcher
      await _showSharingOptions(shareContent);

    } catch (e) {
      _showErrorSnackBar("Error sharing post: $e");
      debugPrint("Error sharing post: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _showSharingOptions(String content) async {
    final encodedContent = Uri.encodeComponent(content);

    // Show a bottom sheet with sharing options
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Share via",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSharingOption(
                      context: context,
                      icon: Icons.sms,
                      label: "SMS",
                      onTap: () async {
                        Navigator.pop(context);
                        final Uri smsUri = Uri.parse('sms:?body=$encodedContent');
                        await _launchUrl(smsUri);
                      },
                    ),
                    _buildSharingOption(
                      context: context,
                      icon: Icons.email,
                      label: "Email",
                      onTap: () async {
                        Navigator.pop(context);
                        final Uri emailUri = Uri.parse(
                            'mailto:?subject=Check out this post on Eyedra!&body=$encodedContent'
                        );
                        await _launchUrl(emailUri);
                      },
                    ),
                    _buildSharingOption(
                      context: context,
                      icon: Icons.copy,
                      label: "Copy",
                      onTap: () async {
                        Navigator.pop(context);
                        await _copyToClipboard(content);
                      },
                    ),
                    _buildSharingOption(
                      context: context,
                      icon: Icons.more_horiz,
                      label: "More",
                      onTap: () {
                        Navigator.pop(context);
                        // If available on the device, this might open the system share sheet
                        _tryNativeShare(content);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSharingOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      _showErrorSnackBar("Couldn't open sharing option");
      debugPrint("Error launching URL: $e");
    }
  }

  Future<void> _copyToClipboard(String text) async {
    try {
      // Import this at the top: import 'package:flutter/services.dart';
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Content copied to clipboard")),
        );
      }
    } catch (e) {
      _showErrorSnackBar("Couldn't copy to clipboard");
      debugPrint("Error copying to clipboard: $e");
    }
  }

  void _tryNativeShare(String text) {
    // This is a placeholder for potential native share functionality
    // Some devices might allow this through platform channels
    // As a fallback, we just copy to clipboard
    _copyToClipboard(text);
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }
}