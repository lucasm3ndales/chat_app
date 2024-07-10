import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/model/user_model.dart' as model;
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<Stream<List<model.User>>> getUsers() async {
    var userId = await getCurrentUserId();

    await Future.delayed(Duration(milliseconds: 600));

    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
        final u = doc.data();
        return model.User.fromMap(u);
      }).where((user) => user.id != userId).toList();
    });
  }

  Future<Stream<List<model.User>>> getChats() async {
    var userId = await getCurrentUserId();
    var currentUserRef = _firestore.collection('users').doc(userId);

    var query = _firestore.collection('chats').where(
        Filter.or(
            Filter("user1", isEqualTo: currentUserRef),
            Filter("user2", isEqualTo: currentUserRef)
        ));

    return query.snapshots().asyncMap((querySnapshot) async {
      List<model.User> users = [];

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

        if (otherUserData != null && otherUserData.isNotEmpty) {
          users.add(model.User.fromMap(otherUserData));
        }
      }

      return users;
    });
  }


  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }

  Future<model.User> getCurrentUser() async {
    try {
      var userId = await getCurrentUserId();

      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        await Future.delayed(Duration(milliseconds: 600));
        return model.User.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

}
