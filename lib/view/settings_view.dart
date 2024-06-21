import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/storage_service.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  final StorageService storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;

  Future<void> pickImage(ImageSource imageSource) async {
    final picked = await _picker.pickImage(source: imageSource);
    if (picked != null) {
      final File imageFile = File(picked.path);
      try {
        final url = await storageService.uploadImage(imageFile);
        setState(() {
          _imageUrl = url;
        });

      } catch (ex) {
        CherryToast.error(
          toastPosition: Position.top,
          backgroundColor: Theme.of(context).colorScheme.background,
          iconWidget: Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: 12,
          displayCloseButton: false,
          animationType: AnimationType.fromTop,
          toastDuration: const Duration(seconds: 3),
          title: Text(
            'Erro ao fazer upload da imagem!',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w700),
          ),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Future<String?> userId = userService.getCurrentUserId();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: userId,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                    'Erro ao buscar usuário!',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text(
                    'Usuário não encontrado!',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                } else {
                  final uid = snapshot.data!;

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (userSnapshot.hasError) {
                        return Text(
                          'Erro ao buscar usuário!',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      } else if (!userSnapshot.hasData ||
                          !userSnapshot.data!.exists) {
                        return Text(
                          'Usuário não encontrado!',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      } else {
                        final user =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                        final phone = formatPhoneNumber(user['phone']);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            _buildProfileImage(user['profileImageUrl']),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              user['name'],
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Email: ${user['email']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'Telefone: $phone',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'País: ${user['country']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'Cidade: ${user['city']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
            Expanded(child: Container()),
            CustomButton(
              text: 'LOGOUT',
              onPressed: () {
                authService.signOut();
              },
            ),
            const SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? profileUrl) {
    if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: () => _showProfileImageDialog(_imageUrl!),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(_imageUrl!),
            ),
            Positioned(
              right: 0,
              bottom: 10,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.add_a_photo_outlined,
                    size: 20, color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        ),
      );
    } else if (profileUrl != null && profileUrl.isNotEmpty) {
      return GestureDetector(
        onTap: () => _showProfileImageDialog(profileUrl),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(profileUrl),
            ),
            Positioned(
              right: 0,
              bottom: 10,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.add_a_photo_outlined,
                    size: 20, color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _showProfileImageDialog(''),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              child: Icon(Icons.person,
                  size: 80, color: Theme.of(context).colorScheme.background),
            ),
            Positioned(
              right: 0,
              bottom: 10,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.add_a_photo_outlined,
                    size: 20, color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showProfileImageDialog(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        pickImage(ImageSource.camera);
                      },
                      child: Text(
                        'Câmera',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        pickImage(ImageSource.gallery);
                      },
                      child: Text(
                        'Galeria',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  child: Icon(Icons.person,
                      size: 40,
                      color: Theme.of(context).colorScheme.background),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        pickImage(ImageSource.camera);
                      },
                      child: Text(
                        'Câmera',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        pickImage(ImageSource.gallery);
                      },
                      child: Text(
                        'Galeria',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 11) {
      return '+${digitsOnly.substring(0, 2)} ${digitsOnly.substring(2, 4)} ${digitsOnly.substring(4, 5)} ${digitsOnly.substring(5, 9)} ${digitsOnly.substring(9)}';
    } else {
      return phoneNumber;
    }
  }
}
