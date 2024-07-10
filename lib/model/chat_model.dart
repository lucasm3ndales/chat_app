import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  User user1;
  User user2;
  String lastMessage;


  Chat({
    required this.id,
    required this.user1,
    required this.user2,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1': user1.toMap(),
      'user2': user2.toMap(),
      'lastMessage': lastMessage,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> obj) {
    return Chat(
      id: obj['id'],
      user1: obj['user1'],
      user2: obj['user2'],
      lastMessage: obj['lastMessage'],
    );
  }
}

class ChatDTO {
  String id;
  DocumentReference<Map<String, dynamic>> user1;
  DocumentReference<Map<String, dynamic>> user2;
  String lastMessage;

  ChatDTO({
    required this.id,
    required this.user1,
    required this.user2,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1': user1,
      'user2': user2,
      'lastMessage': lastMessage,
    };
  }

  factory ChatDTO.fromMap(Map<String, dynamic> obj) {
    return ChatDTO(
      id: obj['id'],
      user1: obj['user1'],
      user2: obj['user2'],
      lastMessage: obj['lastMessage'],
    );
  }
}


