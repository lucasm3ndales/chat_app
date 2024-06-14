import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/widget/user_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  UsersView({super.key});

  @override
  State<UsersView> createState() => _UserViewState();
}

class _UserViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: AppBar(
            title: Text(
              'Usuários',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
      body: _userListWidget(),
    );
  }
}

Widget _userListWidget() {
  final UserService _userService = UserService();

  return StreamBuilder(
      stream: _userService.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        return ListView(
          children: snapshot.data!.map<Widget>((user) => _userListItem(user, context)).toList(),
        );
      });
}

Widget _userListItem(Map<String, dynamic> user, BuildContext context) {
  return UserItem(
      name: user['name'],
      phone: user['phone'],
      onTap: () {
        print('CHAT');
        Navigator.pushNamed(context, '/chat');
      }
  );
}

