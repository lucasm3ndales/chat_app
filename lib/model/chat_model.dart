

import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';

class Chat {
  User sender;
  User receiver;
  DateTime createdAt;
  Message lastMessage;
  List<Message> messages = [];


  Chat({
    required this.sender,
    required this.receiver,
    required this.lastMessage,
    required this.createdAt,
    required this.messages
  });
}