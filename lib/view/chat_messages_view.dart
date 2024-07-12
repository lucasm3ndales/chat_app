import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/storage_service.dart';
import 'package:chat_app/view/profile_view.dart';
import 'package:chat_app/widget/custom_field.dart';
import 'package:chat_app/widget/custom_safearea.dart';
import 'package:chat_app/widget/send_button.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ChatMessagesView extends StatefulWidget {
  ChatMessagesView({super.key, required this.receiver});

  final User receiver;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final StorageService _storageService = StorageService();
  final ScrollController _scrollController = ScrollController();

  @override
  State<ChatMessagesView> createState() => _ChatMessagesViewState();

  void sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _chatService.sendMessage(_messageController.text, receiver.id);
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String downloadUrl = await _storageService.uploadToChat(imageFile);
      await _chatService.sendMessage(downloadUrl, receiver.id, isImage: true);

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  void saveImageToGallery(String imageUrl, BuildContext context) async {
    try {
      Uint8List bytes =
          (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
              .buffer
              .asUint8List();
      await ImageGallerySaver.saveImage(bytes);

      CherryToast.success(
        toastPosition: Position.top,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconWidget: Icon(
          Icons.check_circle_outline_outlined,
          color: Theme.of(context).colorScheme.surface,
        ),
        borderRadius: 12,
        displayCloseButton: false,
        animationType: AnimationType.fromTop,
        toastDuration: const Duration(seconds: 3),
        title: Text(
          'Imagem salva com sucesso na galeria!',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w700),
        ),
      ).show(context);
    } catch (e) {
      CherryToast.error(
        toastPosition: Position.top,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconWidget: Icon(
          Icons.check_circle_outline_outlined,
          color: Theme.of(context).colorScheme.surface,
        ),
        borderRadius: 12,
        displayCloseButton: false,
        animationType: AnimationType.fromTop,
        toastDuration: const Duration(seconds: 3),
        title: Text(
          'Erro ao salvar imagem na galeria!',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w700),
        ),
      ).show(context);
    }
  }
}

class _ChatMessagesViewState extends State<ChatMessagesView> {
  bool isInitLoad = true;


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    widget._scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      height: 20,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 80.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.background, size: 25),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: 24,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileView(user: widget.receiver)),
              );
            },
            child: Row(
              children: [
                _buildUserProfileImage(widget.receiver.profileImageUrl!),
                const SizedBox(width: 14),
                Text(capitalize(widget.receiver.name)),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessagesList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<List<Message>>(
      stream: widget._chatService.getMessages(widget.receiver.id),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar mensagens: ${snapshot.error}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            '${capitalize(widget.receiver.name)} está esperando você dizer olá!',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ));
        } else {

          if (isInitLoad) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            isInitLoad = false;
          }

          return ListView.builder(
            controller: widget._scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Message message = snapshot.data![index];
              bool isSent = message.senderId == widget.receiver.id;
              String sentAt = _formatDateTime(message.sentAt);
              bool isImage = message.isImage;

              return Align(
                alignment:
                    isSent ? Alignment.centerLeft : Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSent
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: isImage
                        ? _buildImageMessage(message.content)
                        : _buildTextMessage(
                            message.content, isSent, context, sentAt),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildTextMessage(
      String messageText, bool isSent, BuildContext context, String sentAt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          messageText,
          style: TextStyle(
            color: isSent
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.background,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            sentAt,
            style: TextStyle(
              color: isSent
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.background,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageMessage(String imageUrl) {
    return GestureDetector(
      onTap: () {
        widget.saveImageToGallery(imageUrl, context);
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error, color: Theme.of(context).colorScheme.error,),
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.error),
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        radius: 25,
        child: Icon(Icons.person,
            size: 25, color: Theme.of(context).colorScheme.background),
      );
    }
  }

  Widget _buildMessageInput() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CustomField(
              controller: widget._messageController,
              isFiled: true,
              filedColor: Theme.of(context).colorScheme.tertiary,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
              hintText: 'Escreva algo para ${capitalize(widget.receiver.name)}',
            ),
          ),
          SendButton(
            sendMessageCallback: widget.sendMessage,
            sendImageCallback: widget.sendImage,
            messageController: widget._messageController,
          )
        ],
      ),
    );
  }

  void _scrollToBottom() {
    widget._scrollController.jumpTo(widget._scrollController.position.maxScrollExtent);
  }

  bool whoSentMessage(Map<String, dynamic> message) {
    if (widget.receiver.id == message['senderId']) {
      return true;
    }
    return false;
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

  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDateTime = DateFormat('HH:mm').format(dateTime);
    return formattedDateTime;
  }
}
