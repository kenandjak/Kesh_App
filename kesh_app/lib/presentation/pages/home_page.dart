import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/home_controller.dart';
import '../widgets/balance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/nav_bar.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = GetIt.I<HomeController>();
  int _currentIndex = 0;

  static const _backgroundColor = Color(0xFFF2F4F2);

  @override
  void initState() {
    super.initState();
    // Chama o carregamento dos dados após o primeiro frame da tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Aqui você passará o ID do usuário que fez o login.
      // Por enquanto, usamos um ID provisório para não quebrar.
      _controller.loadData('USR-12345');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            if (_controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            if (_controller.errorMessage != null) {
              return Center(
                child: Text(
                  _controller.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(
                    userName: _controller.userName,
                    formattedDate: _controller.currentDateFormatted,
                  ),
                  const SizedBox(height: 24),
                  BalanceCard(
                    balance: _controller.balance,
                    walletId: _controller.walletId,
                    isBalanceVisible: _controller.isBalanceVisible,
                    onToggleVisibility: _controller.toggleBalanceVisibility,
                  ),
                  const SizedBox(height: 32),
                  const QuickActions(),
                  const SizedBox(height: 32),
                  RecentActivity(transactions: _controller.recentTransactions),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
