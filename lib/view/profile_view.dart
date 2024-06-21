import 'package:chat_app/widget/custom_safearea.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.user});
  final Map<String, dynamic> user;

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
                      Icons.arrow_back_outlined,
                      color: Theme.of(context).colorScheme.background,
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
    final phone = formatPhoneNumber(user['phone']);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(user['profileImageUrl'] ?? 'https://via.placeholder.com/150'),
          ),
          const SizedBox(height: 16),
          Text(
            user['name'],
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'E-mail: ${user['email']}',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Telefone: ${phone}',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'País: ${user['country']}',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Cidade: ${user['city']}',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.background,
            ),
          ),

        ],
      ),
    );
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
