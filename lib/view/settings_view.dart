import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomButton(text: 'LOGOUT', onPressed: () => {
        authService.signOut()
      })
    );
  }
}
