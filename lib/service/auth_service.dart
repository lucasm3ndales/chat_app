import 'dart:convert';
import 'package:chat_app/model/user_model.dart' as model;
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<auth.UserCredential> siginWithEmailPass(
      String email, String password) async {
    try {
      auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on auth.FirebaseAuthException catch (ex) {
      throw Exception(ex);
    }
  }

  Future<String> signUp(model.UserDTO dto) async {
    try {
      auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: dto.email,
        password: dto.password,
      );

      String? id = userCredential.user?.uid;

      String encrypted = sha256.convert(utf8.encode(dto.password.trim())).toString();

      String phone = dto.phone.replaceAll(RegExp(r'\D'), '').trim();

      model.User user = new model.User(
          id: id!,
          name: dto.name.toLowerCase().trim(),
          phone: phone,
          email: dto.email.trim(),
          password: encrypted,
          country: dto.country.toLowerCase().trim(),
          city: dto.city.toLowerCase().trim()
      );

      await FirebaseFirestore.instance.collection('users').doc(id).set(user.toMap());

      return 'Conta criada com sucesso!';
    } on auth.FirebaseAuthException catch (ex) {
      throw Exception(ex);
    }
  }


  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
