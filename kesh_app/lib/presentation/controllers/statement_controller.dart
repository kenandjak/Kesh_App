import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../application/usecases/get_transactions.dart';
import '../../domain/entities/transaction.dart';

class StatementController extends ChangeNotifier {
  final GetTransactions _getTransactions;

  StatementController(this._getTransactions);

  bool isLoading = false;
  String? errorMessage;

  List<Transaction> transactions = [];

  final String initials = 'LM';

  String get currentDateFormatted {
    final now = DateTime.now();

    final formatter = DateFormat("EEEE, d 'DE' MMMM", 'pt_BR');

    return formatter.format(now).toUpperCase();
  }

  bool isCurrentMonth(Transaction transaction) {
    final now = DateTime.now();

    return transaction.dateTime.year == now.year &&
        transaction.dateTime.month == now.month &&
        transaction.status == TransactionStatus.completed;
  }

  double get totalIn {
    return transactions
        .where((t) => isCurrentMonth(t) && t.receiverId == currentWalletId)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalOut {
    return transactions
        .where((t) => isCurrentMonth(t) && t.senderId == currentWalletId)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  String currentWalletId = '';

  Future<void> loadTransactions(String walletId) async {
    currentWalletId = walletId;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      transactions = await _getTransactions.execute(walletId);

      transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } catch (e) {
      errorMessage = 'Não foi possível carregar o extrato.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isIncoming(Transaction transaction) {
    return transaction.receiverId == currentWalletId;
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

  String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();

    if (DateUtils.isSameDay(date, now)) {
      return 'Hoje, ${DateFormat('HH:mm').format(date)}';
    }

    if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Ontem, ${DateFormat('HH:mm').format(date)}';
    }

    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
