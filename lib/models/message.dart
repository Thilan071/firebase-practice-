class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final String content;
  final DateTime timestamp;
  final String? imageUrl;
  final String chatId;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    required this.content,
    required this.timestamp,
    this.imageUrl,
    required this.chatId,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      senderPhotoUrl: map['senderPhotoUrl'],
      content: map['content'],
      timestamp: map['timestamp'].toDate(),
      imageUrl: map['imageUrl'],
      chatId: map['chatId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'content': content,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'chatId': chatId,
    };
  }
}
