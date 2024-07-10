import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:flutter/material.dart';
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

  Future<void> pickImage(ImageSource imageSource) async {
    final picked = await _picker.pickImage(source: imageSource);
    if (picked != null) {
      final File imageFile = File(picked.path);
      try {
        await storageService.uploadImageToProfile(imageFile);
        setState(() {});
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
    final UserService userService = UserService();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: FutureBuilder<User>(
            future: userService.getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (!snapshot.hasData || snapshot.hasError) {
                return Center(
                  child: Text(
                    'Usuário não encontrado!',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              } else {
                final user = snapshot.data!;
                final phone = formatPhoneNumber(user.phone);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    _buildProfileImage(user.profileImageUrl!),
                    const SizedBox(height: 20.0),
                    Text(
                      capitalize(user.name),
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Email: ${user.email}',
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
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'País: ${capitalize(user.country)}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Cidade: ${capitalize(user.city)}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Expanded(child: Container()),
                    CustomButton(
                      text: 'LOGOUT',
                      onPressed: () {
                        authService.signOut();
                      },
                    ),
                    const SizedBox(height: 20.0),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String profileUrl) {
    if (profileUrl.isNotEmpty) {
      return GestureDetector(
        onTap: () => _showProfileImageDialog(profileUrl),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: profileUrl,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 80,
                backgroundColor: Colors.transparent,
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[200],
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.error),
              ),
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

  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    List<String> words = value.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1);
    }).toList();

    return capitalizedWords.join(' ');
  }

  String formatPhoneNumber(String phoneNumber) {
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 13) {
      return '(+${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 4)} ${digitsOnly.substring(4, 5)} ${digitsOnly.substring(5, 9)}-${digitsOnly.substring(9)}';
    } else {
      return phoneNumber;
    }
  }
}
