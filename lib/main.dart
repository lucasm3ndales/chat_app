import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/theme/light_theme.dart';
import 'package:chat_app/view/chats_view.dart';
import 'package:chat_app/view/login_view.dart';
import 'package:chat_app/view/settings_view.dart';
import 'package:chat_app/view/home_view.dart';
import 'package:chat_app/view/register_view.dart';
import 'package:chat_app/view/users_view.dart';
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
      home: LoginView(),
      routes: {
        '/register': (context) => RegisterView(),
        '/home': (context) => HomeView(),
        '/chats': (context) => ChatsView(),
        '/config': (context) => SettingsView(),
        '/users': (context) => UsersView()
      },
    );
  }
}
