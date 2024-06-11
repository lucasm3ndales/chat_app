import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/custom_field.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  RegisterView({Key? key});

  @override
  _RegisterViewState createState() => _RegisterViewState();

}

class _RegisterViewState extends State<RegisterView> {

  final GlobalKey<FormState> _registerForm = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _obscureTextPass = true;
  bool _obscureTextConfirmPass = true;

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
    RegExp regex = RegExp(r'^\(\d{2}\) \d{2} \d \d{8}$');

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

    if (value != _confirmPassController) {
      return 'As senhas não coincidem!';
    }
    return null;
  }

  String? verifyConfirmPass(String value) {
    if (value != _passController) {
      return 'As senhas não coincidem!';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
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
                    color: Theme
                        .of(context)
                        .colorScheme
                        .background,
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
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.message_outlined,
                              size: 50,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
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
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .tertiary,
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
                  color: Theme
                      .of(context)
                      .colorScheme
                      .background,
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
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .error),
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
                        suffixIcon: _obscureTextPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscureTextPass = !_obscureTextPass;
                          });
                        },
                        obscureText: _obscureTextPass,
                      ),
                      const SizedBox(height: 16.0),
                      CustomField(
                        validator: (value) {
                          return verifyConfirmPass(value!);
                        },
                        controller: _confirmPassController,
                        prefixIcon: Icons.lock_outline_sharp,
                        hintText: 'Confirmar Senha*',
                        suffixIcon: _obscureTextConfirmPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscureTextConfirmPass = !_obscureTextConfirmPass;
                          });
                        },
                        obscureText: _obscureTextConfirmPass,
                      ),
                      const SizedBox(height: 32.0),
                      CustomButton(
                        text: 'Criar Conta',
                        onPressed: () =>
                        {
                          if (_registerForm.currentState!.validate())
                            {print('Criar conta')},
                        },
                      ),
                      const SizedBox(height: 72.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text(
                          'Já tem conta? Clique aqui!',
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
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

