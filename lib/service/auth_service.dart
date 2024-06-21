import 'dart:convert';
import 'package:chat_app/model/user_model.dart';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> siginWithEmailPass(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex);
    }
  }

  Future<String> signUp(UserDTO dto) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: dto.email,
        password: dto.password,
      );

      String? uid = userCredential.user?.uid;

      String encrypted = sha256.convert(utf8.encode(dto.password.trim())).toString();

      String phone = dto.phone.replaceAll(RegExp(r'\D'), '').trim();

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': dto.name.toLowerCase().trim(),
        'phone': phone,
        'email': dto.email.trim(),
        'password': encrypted,
        'country': dto.country.toLowerCase().trim(),
        'city': dto.city.toLowerCase().trim(),
        'profileImageUrl': '',
      });

      return 'Conta criada com sucesso!';
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex);
    }
  }


  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
