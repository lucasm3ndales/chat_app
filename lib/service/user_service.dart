import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<List<Map<String, dynamic>>> getUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final user = doc.data();
            return user;
          }).toList();
    });
  }

  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }

  Future<Map<String, dynamic>> getUser(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();

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
