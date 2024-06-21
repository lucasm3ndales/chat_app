import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:chat_app/view/profile_view.dart';
import 'package:chat_app/widget/custom_field.dart';
import 'package:chat_app/widget/custom_safearea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessagesView extends StatefulWidget {
  ChatMessagesView({super.key, required this.receiver});

  final Map<String, dynamic> receiver;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final UserService _userService = UserService();

  @override
  State<ChatMessagesView> createState() => _ChatMessagesViewState();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(_messageController.text, receiver['uid']);
      _messageController.clear();
    }
  }
}

class _ChatMessagesViewState extends State<ChatMessagesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          CustomSafeArea(
            height: 120,
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
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.receiver['imageUrl'] ??
                        'https://via.placeholder.com/150'),
                    radius: 20,
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(user: widget.receiver,)));
                    },
                    child: Text(
                      widget.receiver['name'],
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
                  child: _buildMessageList(),
                ),
                _buildUserInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return FutureBuilder<String?>(
      future: widget._userService.getCurrentUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao buscar o ID do usuário!'));
        }

        // Verifica se snapshot.data não é nulo antes de usá-lo
        String? senderId = snapshot.data;
        if (senderId == null) {
          return const Center(child: Text('ID do usuário não encontrado!'));
        }

        return StreamBuilder<QuerySnapshot>(
          stream:
              widget._chatService.getMessages(senderId, widget.receiver['uid']),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao buscar mensagens!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Nenhuma mensagem encontrada.'));
            }

            // Exemplo de construção da lista de mensagens
            return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildMessageItem(doc))
                  .toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    Timestamp timestamp = data['sentAt'];
    DateTime dateTime = timestamp.toDate();
    String formatted = DateFormat().add_Hm().format(dateTime);

    return FutureBuilder<bool>(
      future: widget._chatService.isSentMessage(data),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          bool isSentMessage = snapshot.data ?? false;

          return Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
            child: Row(
              mainAxisAlignment: isSentMessage
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: isSentMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isSentMessage
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['message'],
                            style: TextStyle(
                                fontSize: 16.0,
                                color: isSentMessage
                                    ? Theme.of(context).colorScheme.background
                                    : Theme.of(context).colorScheme.secondary),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              Text(
                                formatted,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          Expanded(
            child: CustomField(
              controller: widget._messageController,
              hintText: 'Escrever...',
              obscureText: false,
              isFiled: true,
              filedColor: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
                onPressed: widget.sendMessage,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.background,
                )),
          )
        ],
      ),
    );
  }
}
