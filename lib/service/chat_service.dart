import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendMessage(String message, String receiverId) async {
    final String currentUserId = _auth.currentUser!.uid;

    Map<String, dynamic> currentUser = await _userService.getUser(currentUserId);

    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        message: message,
        senderId: currentUserId,
        receiverId: receiverId,
        sentAt: timestamp,
        senderName: currentUser['name']);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatId = ids.join('_');

    await _firestore.collection('chats').doc(chatId).collection('messages').add(
        newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId_1, String userId_2) {
    List<String> ids = [userId_1, userId_2];
    ids.sort();
    String chatId = ids.join('_');

    return _firestore.collection('chats').doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots();
  }

  Future<bool> isSentMessage(Map<String, dynamic> message) async {
    String? senderId = await _userService.getCurrentUserId();
    if (senderId != null && senderId == message['senderId']) {
      return true;
    }
    return false;
  }
}
