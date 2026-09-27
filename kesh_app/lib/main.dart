// lib/main.dart
import 'package:flutter/material.dart';

import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a injeção de dependências
  await di.init();

  runApp(const KeshApp());
}

class KeshApp extends StatelessWidget {
  const KeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kesh',
      home: Scaffold(body: Center(child: Text('Kesh App Inicializado'))),
    );
  }
}
