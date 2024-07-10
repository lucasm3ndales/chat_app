import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String content;
  String senderId;
  String receiverId;
  Timestamp sentAt;
  bool isImage;

  Message({
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.isImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'sentAt': sentAt,
      'content': content,
      'isImage': isImage,
    };
  }

  factory Message.fromMap(Map<String, dynamic> obj) {
    return Message(
      content: obj['content'],
      senderId: obj['senderId'],
      receiverId: obj['receiverId'],
      sentAt: obj['sentAt'],
      isImage: obj['isImage'],
    );
  }
}
