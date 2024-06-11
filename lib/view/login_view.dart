import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_field.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // Obtém a altura da tela
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Container(
            width: double.infinity, // Largura total
            height: screenHeight * 0.3, // Altura 30% da tela
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary, // Cor de fundo
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Icon(
                    Icons.message,
                    size: 100,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                const SizedBox(height: 14.0), // Espaço entre o ícone e o texto
                Text(
                  'Chat App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 72.0),
            color: Theme.of(context).colorScheme.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 16.0),
                InputField(
                  controller: _passController,
                  hintText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 32.0),
                CustomButton(text: 'Logar', onPressed: () => {})

              ],
            ),
          ),
        ],
      ),
    );
  }
}
