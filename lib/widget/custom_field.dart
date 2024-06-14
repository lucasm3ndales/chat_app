import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? description;

  const CustomField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: validator,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
              icon: Icon(suffixIcon),
              onPressed: onSuffixIconPressed,
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              description!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12.0,
              ),
            ),
          ),
      ],
    );
  }
}
