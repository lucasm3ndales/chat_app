import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_field.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _registerForm = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController =
      MaskedTextController(mask: '(+00) 00 0 0000-0000');
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;

  String? verifyName(String value) {
    if (value.isEmpty) {
      return 'Nome requerido!';
    }

    if (value.length < 4) {
      return 'Nome deve ter no mínimo 4 characteres!';
    }

    return null;
  }

  String? verifyEmail(String value) {
    RegExp regex = RegExp(r'^.{3,}@.*$');

    if (value.isEmpty) {
      return 'E-mail requerido!';
    }

    if (!value.contains('@')) {
      return 'Formato de e-mail inválido: xxx...@example.com!';
    }

    if (!regex.hasMatch(value)) {
      return 'E-mail deve ter no mínimo 3 characteres: xxx...@example.com!';
    }

    return null;
  }

  String? verifyPhone(String value) {
    RegExp regex = RegExp(r'^\(\+\d{2}\) \d{2} \d \d{4}-\d{4}$');

    if (value.isEmpty) {
      return 'Telefone requerido!';
    }

    if (!regex.hasMatch(value)) {
      return 'Formato de telefone inválido: (+xx) xx x xxxx-xxxx';
    }

    return null;
  }

  String? verifyPass(String value) {
    if (value.isEmpty) {
      return 'Senha requerida!';
    }

    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 characteres';
    }

    if (value == _nameController) {
      return 'A senha não pode ser igual ao nome do usuário';
    }

    if (value != _confirmPassController.text) {
      return 'As senhas não coincidem!';
    }

    return null;
  }

  String? verifyConfirmPass(String value) {
    if (value.isEmpty) {
      return 'Senha requerida!';
    }

    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 characteres';
    }

    if (value == _nameController) {
      return 'A senha não pode ser igual ao nome do usuário';
    }

    if (value != _passController.text) {
      return 'As senhas não coincidem!';
    }

    return null;
  }

  void submitForm(BuildContext context) async {
    if (_registerForm.currentState!.validate()) {
      final AuthService authService = AuthService();
      UserDTO dto = UserDTO(
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passController.text);
      try {
        String res = await authService.signUp(dto);

        if (res.isNotEmpty) {

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
              res,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w700),
            ),
          ).show(context);
          Navigator.pop(context, '/');
        }
      } catch (ex) {
        CherryToast.error(
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
            'Erro ao criar conta de usuário!',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w700),
          ),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _registerForm,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 64.0),
                  height: screenHeight * 0.1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chat App',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.message_outlined,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Crie sua conta!',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 72.0),
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Campos Requeridos*',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      CustomField(
                        validator: (value) {
                          return verifyName(value!);
                        },
                        controller: _nameController,
                        prefixIcon: Icons.account_circle_outlined,
                        hintText: 'Nome*',
                      ),
                      const SizedBox(height: 16.0),
                      CustomField(
                        validator: (value) {
                          return verifyEmail(value!);
                        },
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        hintText: 'E-mail*',
                      ),
                      const SizedBox(height: 16.0),
                      CustomField(
                        validator: (value) {
                          return verifyPhone(value!);
                        },
                        controller: _phoneController,
                        description: 'Telefone: (+xx) xx x xxxx-xxxx',
                        prefixIcon: Icons.phone_android_outlined,
                        hintText: 'Telefone*',
                      ),
                      const SizedBox(height: 16.0),
                      CustomField(
                        validator: (value) {
                          return verifyPass(value!);
                        },
                        controller: _passController,
                        hintText: 'Senha*',
                        prefixIcon: Icons.lock_outline_sharp,
                        suffixIcon: obscureTextPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            obscureTextPass = !obscureTextPass;
                          });
                        },
                        obscureText: obscureTextPass,
                      ),
                      const SizedBox(height: 16.0),
                      CustomField(
                        validator: (value) {
                          return verifyConfirmPass(value!);
                        },
                        controller: _confirmPassController,
                        prefixIcon: Icons.lock_outline_sharp,
                        hintText: 'Confirmar Senha*',
                        suffixIcon: obscureTextConfirmPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            obscureTextConfirmPass = !obscureTextConfirmPass;
                          });
                        },
                        obscureText: obscureTextConfirmPass,
                      ),
                      const SizedBox(height: 32.0),
                      CustomButton(
                        text: 'Criar Conta',
                        onPressed: () => {submitForm(context)},
                      ),
                      const SizedBox(height: 72.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text(
                          'Já tem conta? Clique aqui!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Seu conteúdo de registro aqui
              ],
            ),
          ),
        ),
      ),
    );
  }
}
