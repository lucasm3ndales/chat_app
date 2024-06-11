import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/theme/light_theme.dart';
import 'package:chat_app/view/home_view.dart';
import 'package:chat_app/view/register_view.dart';
import 'package:chat_app/widget/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const AuthGate(),
      routes: {
        '/register': (context) => RegisterView(),
        '/home': (context) => HomeView(),
      },
    );
  }
}
