import 'package:flutter/material.dart';

import '../../domain/entities/transaction.dart';
import '../controllers/statement_controller.dart';

class StatementBoard extends StatelessWidget {
  final StatementController controller;

  const StatementBoard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryBox(
            title: 'Entradas este mês',
            amount: '+ ${controller.formatCurrency(controller.totalIn)}',
            backgroundColor: const Color(0xFFF2FAF2),
            textColor: Colors.green.shade700,
          ),

          const SizedBox(height: 12),

          _buildSummaryBox(
            title: 'Saídas este mês',
            amount: '- ${controller.formatCurrency(controller.totalOut)}',
            backgroundColor: const Color(0xFFF5F5F5),
            textColor: Colors.black87,
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Todas as movimentações',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${controller.transactions.length} transações encontradas',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (controller.transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Nenhuma movimentação encontrada.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
          else
            Column(
              children: controller.transactions
                  .map(_buildTransactionItem)
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox({
    required String title,
    required String amount,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction tx) {
    final isIncoming = controller.isIncoming(tx);

    final iconData = tx.type == TransactionType.payment
        ? Icons.shopping_bag_outlined
        : tx.type == TransactionType.simulatedDeposit
        ? Icons.account_balance_wallet_outlined
        : isIncoming
        ? Icons.arrow_downward
        : Icons.arrow_upward;

    final iconColor = isIncoming ? Colors.green.shade700 : Colors.grey.shade700;

    final bgColor = isIncoming ? Colors.green.shade100 : Colors.grey.shade200;

    final amountColor = isIncoming ? Colors.green.shade700 : Colors.black87;

    final prefix = isIncoming ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(iconData, color: iconColor, size: 20),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.getTransactionTitle(tx),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.formatDate(tx.dateTime),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '$prefix ${controller.formatCurrency(tx.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
