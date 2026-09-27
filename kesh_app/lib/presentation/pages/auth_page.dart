import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/auth_controller.dart';
import '../../domain/repositories/auth_strategy.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final controller = GetIt.I<AuthController>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kesh - Login')),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.session != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Logado com: ${controller.session!.provider}'),
                  Text('ID do Usuário: ${controller.session!.userId}'),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: controller.logout,
                    child: const Text('Sair'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    final strategy = GetIt.I<AuthStrategy>(
                      instanceName: 'emailStrategy',
                      param1: emailController.text,
                      param2: passwordController.text,
                    );
                    controller.loginWith(strategy);
                  },
                  child: const Text('Entrar'),
                ),

                const SizedBox(height: 10),

                OutlinedButton(
                  onPressed: () {
                    final strategy = GetIt.I<AuthStrategy>(
                      instanceName: 'googleStrategy',
                    );
                    controller.loginWith(strategy);
                  },
                  child: const Text('Entrar com Google'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
