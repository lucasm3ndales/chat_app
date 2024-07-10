import 'dart:io';
import 'package:chat_app/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final UserService _userService = UserService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> uploadImageToProfile(File image) async {
      final userId = await _userService.getCurrentUserId();

      if (userId == null) {
        throw Exception('Usuário não encontrado!');
      }

      final storageRef = _storage.ref().child('profile_pictures').child('$userId.jpg');
      final uploadTask = storageRef.putFile(image);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('users').doc(userId).update({'profileImageUrl': downloadUrl});
  }

  Future<String> uploadToChat(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = _storage.ref().child("chat_images").child(fileName);

    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

}