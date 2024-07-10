import 'package:flutter/material.dart';

class SendButton extends StatefulWidget {
  final VoidCallback sendMessageCallback;
  final VoidCallback sendImageCallback;
  final TextEditingController messageController;

  const SendButton({
    Key? key,
    required this.sendMessageCallback,
    required this.sendImageCallback,
    required this.messageController,
  }) : super(key: key);

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  bool isEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.messageController.addListener(_onTextChanged);
    _onTextChanged();
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      isEmpty = widget.messageController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isEmpty,
      child: IconButton(
        icon: Icon(Icons.send, color: Theme.of(context).colorScheme.background),
        onPressed: () {
          widget.sendMessageCallback();
          widget.messageController.clear();
        },
      ),
      replacement: IconButton(
        icon: Icon(Icons.image, color: Theme.of(context).colorScheme.background),
        onPressed: () {
          widget.sendImageCallback();
          widget.messageController.clear();
        },
      ),
    );
  }
}
