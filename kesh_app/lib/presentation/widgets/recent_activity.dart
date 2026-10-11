import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';

class RecentActivity extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentActivity({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
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
                // Futuramente redireciona para a aba de Extrato
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

        Column(
          children: transactions
              .map((tx) => _buildTransactionItem(tx))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction tx) {
    // Para simplificar, estamos usando o isPositive, mas futuramente
    // poderíamos olhar para o TransactionType (deposito, pagamento, transferencia)
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
                  tx.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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

          // Valor Monetário
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
