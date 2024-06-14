

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getUsers() {
    return _firestore.collection('users')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final user = doc.data();
            return user;
          }).toList();
    });
  }
}