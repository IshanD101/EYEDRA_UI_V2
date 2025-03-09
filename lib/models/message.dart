class ChatMessage {
  final String text;
  final bool isFromMe;
  final String? senderName;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isFromMe,
    this.senderName,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}