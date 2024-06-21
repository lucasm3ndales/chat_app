import 'package:flutter/material.dart';

class CustomSafeArea extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
   final double height;

  const CustomSafeArea({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.transparent,
    required this.height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}