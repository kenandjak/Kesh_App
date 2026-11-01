import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'home_controller.dart';

class StatementController extends ChangeNotifier {
  bool isLoading = false;

  final String initials = 'LM';
  final double totalIn = 850.00;
  final double totalOut = 109.90;

  final List<Transaction> transactions = [
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

  String get currentDateFormatted {
    final now = DateTime.now();
    final formatter = DateFormat("EEEE, d 'DE' MMMM", 'pt_BR');
    return formatter.format(now).toUpperCase();
  }

  String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
