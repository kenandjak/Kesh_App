import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/statement_controller.dart';
import '../widgets/nav_bar.dart';
import '../widgets/statement_board.dart';

class StatementPage extends StatefulWidget {
  final String walletId;

  const StatementPage({super.key, required this.walletId});

  @override
  State<StatementPage> createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  late final StatementController _controller;

  static const _backgroundColor = Color(0xFFF2F4F2);

  @override
  void initState() {
    super.initState();

    _controller = GetIt.I<StatementController>();

    _controller.loadTransactions(widget.walletId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  if (_controller.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (_controller.errorMessage != null) {
                    return Center(
                      child: Column(
                        children: [
                          Text(_controller.errorMessage!),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              _controller.loadTransactions(widget.walletId);
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  return StatementBoard(controller: _controller);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
