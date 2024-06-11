import 'package:chat_app/model/user_model.dart';

class Message {
  String content;
  User sender;
  User receiver;
  DateTime sentAt;

  Message({
    required this.content,
    required this.sender,
    required this.receiver,
    required this.sentAt
  });
}