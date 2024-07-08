import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Stream<List<Map<String, dynamic>>>> getUsers() async {
    var userId = await getCurrentUserId();

    await Future.delayed(Duration(milliseconds: 600));

    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
        final user = doc.data();
        if (user['uid'] != userId) {
          return user;
        }
        return null;
      })
          .where((user) => user != null)
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  Future<Stream<List<Map<String, dynamic>>>> getChats() async {
    var userId = await getCurrentUserId();
    var currentUserRef = _firestore.collection('users').doc(userId);

    var querySnapshot = await _firestore.collection('chats').where(
        Filter.or(
            Filter("user1", isEqualTo: currentUserRef),
            Filter("user2", isEqualTo: currentUserRef)
        )).get();

    List<Map<String, dynamic>> users = [];

    for (var doc in querySnapshot.docs) {
      var chat = doc.data();

      DocumentReference<Map<String, dynamic>> otherUserRef;

      if (chat['user1'] == currentUserRef) {
        otherUserRef = chat['user2'];
      } else {
        otherUserRef = chat['user1'];
      }

      var otherUserDoc = await otherUserRef.get();
      var otherUserData = otherUserDoc.data();

      if (otherUserData!.isNotEmpty) {
        users.add(otherUserData);
      }
    }

    var stream = StreamController<List<Map<String, dynamic>>>();
    stream.add(users);
    return stream.stream;
  }


  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      var userId = await getCurrentUserId();

      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();

      await Future.delayed(Duration(milliseconds: 600));

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

}
