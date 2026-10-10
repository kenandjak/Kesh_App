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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _controller = GetIt.I<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade300, Colors.green.shade900],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, child) {
                  if (_controller.loading) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }

                  if (_controller.session != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Autenticado via: ${_controller.session!.provider}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _controller.logout,
                          child: const Text('Sair'),
                        ),
                      ],
                    );
                  }
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.asset('assets/logo.png', height: 80),
                          const SizedBox(height: 16),
                          const Text(
                            'Kesh',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 48),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              final strategy = GetIt.I<AuthStrategy>(
                                instanceName: 'emailStrategy',
                                param1: _emailController.text,
                                param2: _passwordController.text,
                              );
                              _controller.loginWith(strategy);
                            },
                            child: const Text(
                              'Entrar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.green.shade700),
                            ),
                            icon: Icon(
                              Icons.g_mobiledata,
                              size: 28,
                              color: Colors.green.shade700,
                            ),
                            label: Text(
                              'Entrar com Google',
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                            onPressed: () {
                              final strategy = GetIt.I<AuthStrategy>(
                                instanceName: 'googleStrategy',
                              );
                              _controller.loginWith(strategy);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
