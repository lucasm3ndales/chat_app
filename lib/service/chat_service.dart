import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<void> sendMessage(String content, String receiverId, {bool isImage = false}) async {
    User currentUser = await _userService.getCurrentUser();

    List<String> ids = [currentUser.id, receiverId];
    ids.sort();
    String chatId = ids.join('_');

    var hasChat = await _hasChat(chatId);

    if (!hasChat) {
      DocumentReference<Map<String, dynamic>> user1Ref =
          _firestore.collection('users').doc(currentUser.id);
      DocumentReference<Map<String, dynamic>> user2Ref =
          _firestore.collection('users').doc(receiverId);

      ChatDTO chat = ChatDTO(
        id: chatId,
        user1: user1Ref,
        user2: user2Ref,
        lastMessage: content,
      );

      await _firestore.collection('chats').doc(chatId).set(chat.toMap());
    } else {
      var chatDoc = await _firestore.collection('chats').doc(chatId).get();
      var chat = ChatDTO.fromMap(chatDoc.data() as Map<String, dynamic>);

      chat.lastMessage = content;

      await _firestore.collection('chats').doc(chatId).update(chat.toMap());
    }

    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      content: content,
      senderId: currentUser.id,
      receiverId: receiverId,
      sentAt: timestamp,
      isImage: isImage,
    );

    DocumentReference messageRef = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(newMessage.toMap());

    await messageRef.update(newMessage.toMap());
  }

  Future<bool> _hasChat(String chatId) async {
    var chatSnapshot =
        await _firestore.collection('chats').doc(chatId).get();
    return chatSnapshot.exists;
  }

  Stream<List<Message>> getMessages(String receiverId) async* {
    var senderId = await _userService.getCurrentUserId();

    List<String> ids = [senderId!, receiverId];
    ids.sort();
    String chatId = ids.join('_');

    await Future.delayed(Duration(milliseconds: 600));

    yield* _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data()))
        .toList());
  }

}
