import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<void> sendMessage(String message, String receiverId, { bool isImage = false }) async {
    Map<String, dynamic> currentUser =
        await _userService.getUser();

    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        message: message,
        senderId: currentUser['uid'],
        receiverId: receiverId,
        sentAt: timestamp,
        senderName: currentUser['name'],
        isImage: isImage,

    );

    List<String> ids = [currentUser['uid'], receiverId];
    ids.sort();
    String chatId = ids.join('_');

    DocumentReference user1Ref = _firestore.collection('users').doc(currentUser['uid']);
    DocumentReference user2Ref = _firestore.collection('users').doc(receiverId);

    await _firestore
        .collection('chats')
        .doc(chatId)
        .set({
      'user1': user1Ref,
      'user2': user2Ref,
      'lastMessage': message,
    });

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String receiverId) async* {
    var senderId = await _userService.getCurrentUserId();

    List<String> ids = [senderId!, receiverId];
    ids.sort();
    String chatId = ids.join('_');

    yield* _firestore
        .collection('chats')
        .doc(chatId)
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
