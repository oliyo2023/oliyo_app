class Message {
  final String id;
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime created;
  final bool isRead;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.created,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      senderId: json['sender'],
      receiverId: json['receiver'],
      created: DateTime.parse(json['created']),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': senderId,
      'receiver': receiverId,
      'created': created.toIso8601String(),
      'is_read': isRead,
    };
  }
} 