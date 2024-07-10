import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/view/chat_messages_view.dart';
import 'package:chat_app/widget/user_item.dart';
import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            'Usuários',
            style: TextStyle(
              fontSize: 24.0,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      ),
      body: _userListWidget(),
    );
  }

  Widget _userListWidget() {
    final UserService userService = UserService();

    return FutureBuilder<Stream<List<User>>>(
      future: userService.getUsers(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (futureSnapshot.hasError || !futureSnapshot.hasData) {
          return Center(
            child: Text(
              'Usuários não encontrados!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: StreamBuilder<List<User>>(
            stream: futureSnapshot.data,
            builder: (context, snapshot) {
              final users = snapshot.data ?? [];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListView(
                  children: users
                      .map<Widget>((user) => _userListItem(user, context))
                      .toList(),
                ),
              );
            },
          ),
        );
      },
    );
  }


  Widget _userListItem(User user, BuildContext context) {
    return UserItem(
      url: user.profileImageUrl ?? '',
      name: user.name,
      country: user.country,
      city: user.city,
      onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMessagesView(receiver: user)));
      },
    );
  }
}
