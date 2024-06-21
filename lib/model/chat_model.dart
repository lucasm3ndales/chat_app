

import 'package:chat_app/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String senderId;
  String receiverId;
  Timestamp createdAt;
  Message lastMessage;
  List<Message> messages = [];


  Chat({
    required this.senderId,
    required this.receiverId,
    required this.lastMessage,
    required this.createdAt,
    required this.messages
  });
}