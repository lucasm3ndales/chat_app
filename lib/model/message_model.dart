import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String senderName;
  String senderId;
  String receiverId;
  Timestamp sentAt;
  bool isImage;

  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.senderName,
    required this.isImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'sentAt': sentAt,
      'message': message,
      'isImage': isImage,
    };
  }
}