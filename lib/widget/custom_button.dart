import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.0),
      elevation: 14.0,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(20.0),
        splashColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: _isPressed ? Theme.of(context).colorScheme.primary.withOpacity(0.8) : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
