import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/statement_controller.dart';
import '../widgets/nav_bar.dart';
import '../widgets/statement_board.dart';

class StatementPage extends StatefulWidget {
  const StatementPage({super.key});

  @override
  State<StatementPage> createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  final _controller = GetIt.I<StatementController>();

  static const _backgroundColor = Color(0xFFF2F4F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controller.currentDateFormatted,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Seu extrato',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.black87,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: const Color(0xFFD6F399),
                        foregroundColor: Colors.green.shade900,
                        child: Text(
                          _controller.initials,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Componente Central
              StatementBoard(controller: _controller),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
