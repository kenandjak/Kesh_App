import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
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
            crossAxisAlignment: CrossAxisAlignment.end,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Últimos 30 dias',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Column(
            children: controller.transactions
                .map((tx) => _buildTransactionItem(tx))
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
    final isPayment = tx.title.toLowerCase().contains('café');
    final iconData = isPayment
        ? Icons.local_cafe_outlined
        : (tx.isPositive ? Icons.arrow_downward : Icons.arrow_upward);
    final iconColor = isPayment
        ? Colors.brown.shade700
        : (tx.isPositive ? Colors.green.shade700 : Colors.grey.shade700);
    final bgColor = isPayment
        ? Colors.orange.shade100
        : (tx.isPositive ? Colors.green.shade100 : Colors.grey.shade200);
    final amountColor = tx.isPositive ? Colors.green.shade700 : Colors.black87;
    final prefix = tx.isPositive ? '+' : '-';
    final formattedAmount =
        'R\$ ${tx.amount.toStringAsFixed(2).replaceAll('.', ',')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
                  tx.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tx.subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$prefix $formattedAmount',
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
