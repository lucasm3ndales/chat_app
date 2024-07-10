import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/widget/custom_safearea.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          CustomSafeArea(
            height: 100,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.background,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _buildUserProfile(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    final phone = formatPhoneNumber(user.phone);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         _buildProfileImage(context, user.profileImageUrl!),
          const SizedBox(height: 16),
          Text(
            capitalize(user.name),
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'E-mail: ${user.email}',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Telefone: $phone',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'País: ${capitalize(user.country)}',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Cidade: ${capitalize(user.city)}',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context,  String profileUrl) {
    if (profileUrl.isNotEmpty) {
      return CachedNetworkImage(
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
      );
    } else {
      return CircleAvatar(
        radius: 80,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.person,
            size: 80, color: Theme.of(context).colorScheme.background),
      );
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 13) {
      return '(+${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 4)} ${digitsOnly.substring(4, 5)} ${digitsOnly.substring(5, 9)}-${digitsOnly.substring(9)}';
    } else {
      return phoneNumber;
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

}
