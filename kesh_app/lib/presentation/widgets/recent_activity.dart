import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/transaction.dart';
import '../controllers/home_controller.dart';

class RecentActivity extends StatelessWidget {
  final HomeController controller;

  const RecentActivity({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final transactions = controller.recentTransactions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atividade recente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Acompanhe suas movimentações',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),

            GestureDetector(
              onTap: () {
                context.go('/statement');
              },
              child: Text(
                'Ver extrato completo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        if (transactions.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Nenhuma atividade recente.',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          )
        else
          Column(
            children: transactions
                .map((tx) => _buildTransactionItem(tx))
                .toList(),
          ),
      ],
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
            padding: const EdgeInsets.all(12),
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
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.formatDate(tx.dateTime),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
