import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../application/usecases/get_user_details.dart';
import '../../application/usecases/get_transactions.dart';
import '../../domain/entities/transaction.dart';

class HomeController extends ChangeNotifier {
  final GetUserDetails _getUserDetails;
  final GetTransactions _getTransactions;

  HomeController(this._getUserDetails, this._getTransactions);

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

  List<Transaction> recentTransactions = [];

  Future<void> loadData(String userId) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      // Busca informações do usuário e da carteira.
      final data = await _getUserDetails.execute(userId);

      userName = data.shortName;
      walletId = data.walletId;
      balance = data.balance;

      // Busca as transações da carteira.
      final transactions = await _getTransactions.execute(walletId);

      // Ordena da mais recente para a mais antiga.
      transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      // Mantém somente as quatro últimas atividades.
      recentTransactions = transactions.take(4).toList();
    } catch (e, st) {
      debugPrint('loadData falhou: $e\n$st');

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

  bool isIncoming(Transaction transaction) {
    return transaction.receiverId == walletId;
  }

  String getTransactionTitle(Transaction transaction) {
    switch (transaction.type) {
      case TransactionType.simulatedDeposit:
        return 'Depósito simulado';

      case TransactionType.transfer:
        return isIncoming(transaction)
            ? 'Transferência recebida'
            : 'Transferência enviada';

      case TransactionType.payment:
        return isIncoming(transaction)
            ? 'Pagamento recebido'
            : 'Pagamento realizado';
    }
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    if (isSameDay(date, now)) {
      return 'Hoje, ${DateFormat('HH:mm').format(date)}';
    }

    if (isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Ontem, ${DateFormat('HH:mm').format(date)}';
    }

    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
