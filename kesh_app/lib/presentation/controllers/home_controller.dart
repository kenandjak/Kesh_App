import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  bool isLoading = false;
  bool isBalanceVisible = true;

  // Dados mockados
  // Depois os dados virão do caso de uso (GetUserDetails)
  String userName = 'Mickey';
  String walletId = 'KSH-039284';
  double balance = 2840.65;

  void toggleBalanceVisibility() {
    isBalanceVisible = !isBalanceVisible;
    notifyListeners();
  }

  final List<Transaction> recentTransactions = [
    Transaction(
      title: 'Marina Costa',
      subtitle: 'Transferência recebida · Hoje, 10:30',
      amount: 350.00,
      isPositive: true,
    ),
    Transaction(
      title: 'Café Aurora',
      subtitle: 'Pagamento · Hoje, 08:15',
      amount: 24.90,
      isPositive: false,
    ),
    Transaction(
      title: 'Pedro Lima',
      subtitle: 'Transferência enviada · Ontem, 18:45',
      amount: 85.00,
      isPositive: false,
    ),
    Transaction(
      title: 'Depósito simulado',
      subtitle: 'Adição de saldo · Ontem, 14:02',
      amount: 500.00,
      isPositive: true,
    ),
  ];
}

// Classe auxiliar apenas para transportar dados prontos para a interface
class Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final bool isPositive;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });
}
