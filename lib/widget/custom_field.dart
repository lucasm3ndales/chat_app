import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator; // Função de validação do campo
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed; // Ação a ser executada quando o ícone de sufixo for pressionado

  const CustomField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? IconButton(icon: Icon(suffixIcon), onPressed: onSuffixIconPressed,) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
    );
  }
}
