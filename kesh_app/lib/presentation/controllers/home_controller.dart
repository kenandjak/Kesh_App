import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../application/usecases/get_user_details.dart';

class HomeController extends ChangeNotifier {
  final GetUserDetails _getUserDetails;

  HomeController(this._getUserDetails);
  String get currentDateFormatted {
    final now = DateTime.now();
    final formatter = DateFormat("EEEE, d 'DE' MMMM", 'pt_BR');
    return formatter.format(now).toUpperCase();
  }

  bool isLoading = true;
  bool isBalanceVisible = true;
  String? errorMessage;

  String userName = '';
  String walletId = '';
  double balance = 0.0;

  Future<void> loadData(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _getUserDetails.execute(userId);
      userName = data.userName;
      walletId = data.walletId;
      balance = data.balance;
    } catch (e) {
      errorMessage = 'Falha ao carregar informações.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
