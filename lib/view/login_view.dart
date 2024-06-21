import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/view/register_view.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_field.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String? verifyEmail(String value) {
    RegExp regex = RegExp(r'^.{3,}@.*$');

    if (value.isEmpty || !value.contains('@') || !regex.hasMatch(value)) {
      return 'E-mail inválido!';
    }
    return null;
  }

  String? verifyPass(String value) {
    if (value.isEmpty || value.length < 6) {
      return 'Senha inválida!';
    }
    return null;
  }

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.siginWithEmailPass(
          _emailController.text, _passController.text);
    } catch (ex) {
      CherryToast.error(
        toastPosition: Position.top,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconWidget: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error,),
        borderRadius: 12,
        displayCloseButton: false,
        animationType: AnimationType.fromTop,
        toastDuration: const Duration(seconds: 3),
        title: Text(
          'E-mail ou senha inválidos!',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w700),
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Form(
          key: _loginForm,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      child: Icon(
                        Icons.message_outlined,
                        size: 100,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    const SizedBox(height: 14.0),
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
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 72.0),
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomField(
                      validator: (value) {
                        return verifyEmail(value!);
                      },
                      controller: _emailController,
                      hintText: 'E-mail',
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16.0),
                    CustomField(
                      validator: (value) {
                        return verifyPass(value!);
                      },
                      controller: _passController,
                      hintText: 'Senha',
                      prefixIcon: Icons.lock_outline_sharp,
                      obscureText: true,
                    ),
                    const SizedBox(height: 32.0),
                    CustomButton(
                      text: 'Logar',
                      onPressed: () => {
                        if (_loginForm.currentState!.validate())
                          {login(context)},
                      },
                    ),
                    const SizedBox(height: 72.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterView()));
                      },
                      child: Text(
                        'Não tem conta? Clique aqui!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
