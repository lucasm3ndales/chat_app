import 'dart:io';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/storage_service.dart';
import 'package:chat_app/view/profile_view.dart';
import 'package:chat_app/widget/custom_field.dart';
import 'package:chat_app/widget/custom_safearea.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ChatMessagesView extends StatefulWidget {
  ChatMessagesView({super.key, required this.receiver});

  final Map<String, dynamic> receiver;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final StorageService _storageService = StorageService();

  @override
  State<ChatMessagesView> createState() => _ChatMessagesViewState();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(_messageController.text, receiver['uid']);
      _messageController.clear();
    }
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String downloadUrl = await _storageService.uploadToChat(imageFile);
      await _chatService.sendMessage(downloadUrl, receiver['uid'], isImage: true);
    }
  }
}

class _ChatMessagesViewState extends State<ChatMessagesView> {
  final ValueNotifier<String> _inputText = ValueNotifier<String>('');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget._messageController.addListener(_handleInputChange);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget._messageController.removeListener(_handleInputChange);
    widget._messageController.dispose();
    _inputText.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  void _handleInputChange() {
    _inputText.value = widget._messageController.text;
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  _buildUserProfileImage(widget.receiver['profileImageUrl']),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileView(user: widget.receiver),
                        ),
                      );
                    },
                    child: Text(
                      capitalize(widget.receiver['name']),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: _buildMessageList(),
                  ),
                  _buildUserInput(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileImage(String url) {
    if(url.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(widget.receiver['profileImageUrl']),
        radius: 20,
      );
    } else {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        radius: 20,
        child: Icon(Icons.person,
            size: 25, color: Theme.of(context).colorScheme.background),
      );
    }
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget._chatService.getMessages(widget.receiver['uid']),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao buscar mensagens!'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'Diga algo para ${capitalize(widget.receiver['name'])}!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var message = snapshot.data!.docs[index];
            return _buildMessageItem(message);
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

    bool isImage = data['isImage'] ?? false;

    return FutureBuilder<bool>(
      future: widget._chatService.isSentMessage(data),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          bool isSentMessage = snapshot.data ?? false;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
            child: Row(
              mainAxisAlignment: isSentMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: isSentMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isSentMessage ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isImage)
                            GestureDetector(
                              onTap: () async {
                                Directory docDir = await getApplicationDocumentsDirectory();
                                String filePath = '${docDir.path}/${data['fileName']}';
                                File file = File(filePath);
                                await file.writeAsBytes((await NetworkAssetBundle(Uri.parse(data['message']))
                                    .load(data['message']))
                                    .buffer
                                    .asUint8List());
                                CherryToast.success(
                                  toastPosition: Position.top,
                                  backgroundColor: Theme.of(context).colorScheme.background,
                                  iconWidget: Icon(
                                    Icons.error_outline,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  borderRadius: 12,
                                  displayCloseButton: false,
                                  animationType: AnimationType.fromTop,
                                  toastDuration: const Duration(seconds: 3),
                                  title: Text(
                                    'Imagem salva com sucesso!',
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ).show(context);
                              },
                              child: Image.network(data['message']),
                            )
                          else
                            Text(
                              data['message'],
                              style: TextStyle(
                                fontSize: 16.0,
                                color: isSentMessage ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              Text(
                                formatted,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
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
              hintText: 'Escreva algo para ${capitalize(widget.receiver['name'])}',
              obscureText: false,
              isFiled: true,
              filedColor: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(width: 12),
          ValueListenableBuilder<String>(
            valueListenable: _inputText,
            builder: (context, value, child) {
              return CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  onPressed: value.isNotEmpty ? widget.sendMessage : () => widget.sendImage(),
                  icon: Icon(
                    value.isNotEmpty ? Icons.send : Icons.image_outlined,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    List<String> words = value.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1);
    }).toList();

    return capitalizedWords.join(' ');
  }
}
