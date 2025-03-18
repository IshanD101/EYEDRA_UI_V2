class ChatMessage {
  final String id;
  final String text;
  final bool isFromMe;
  final String? senderName;
  final String senderId;
  final DateTime timestamp;
  final bool isDeleted;
  final String? deletedBy;
  final DateTime? deletedAt;

  ChatMessage({
    String? id,
    required this.text,
    required this.isFromMe,
    this.senderName,
    required this.senderId,
    DateTime? timestamp,
    this.isDeleted = false,
    this.deletedBy,
    this.deletedAt,
  }) :
        this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        this.timestamp = timestamp ?? DateTime.now();

  // Create a copy with updated properties
  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isFromMe,
    String? senderName,
    String? senderId,
    DateTime? timestamp,
    bool? isDeleted,
    String? deletedBy,
    DateTime? deletedAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isFromMe: isFromMe ?? this.isFromMe,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedBy: deletedBy ?? this.deletedBy,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}