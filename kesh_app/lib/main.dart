// lib/main.dart
import 'package:flutter/material.dart';

import 'core/di/injection_container.dart' as di;
import 'presentation/pages/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const KeshApp());
}

class KeshApp extends StatelessWidget {
  const KeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kesh',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}
