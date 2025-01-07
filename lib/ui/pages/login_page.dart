import 'package:casa_inteligente/services/auth_service.dart';
import 'package:casa_inteligente/ui/widgets/custom_password.dart';
import 'package:casa_inteligente/ui/widgets/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
        emailController.value.text,
        passwordController.value.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_outlined,
              size: 150,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            CustomTextFormField(
                labelText: "Usuário", controller: emailController),
            const SizedBox(height: 10),
            CustomPasswordFormField(
                labelText: "Senha", controller: passwordController),
            CustomButton(
              text: "Entrar",
              height: 100,
              onClick: signIn,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Entre para controlar sua casinha",
                  style:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}