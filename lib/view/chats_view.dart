import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/view/chat_messages_view.dart';
import 'package:chat_app/widget/user_item.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            'Chats',
            style: TextStyle(
              fontSize: 24.0,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      ),
      body: _chatListWidget(),
    );
  }

  Widget _chatListWidget() {
    final UserService userService = UserService();

    return FutureBuilder<Stream<List<User>>>(
      future: userService.getChats(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: StreamBuilder<List<User>>(
            stream: futureSnapshot.data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data ?? [];

              if (users.isEmpty) {
                return Center(
                  child: Text(
                    'Chats não encontrados!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                );
              }

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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatMessagesView(receiver: user)));
      },
    );
  }
}
