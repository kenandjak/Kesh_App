import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O que você quer fazer?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Operações rápidas e seguras',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                title: 'Enviar',
                icon: Icons.call_made,
                iconColor: Colors.green.shade700,
                backgroundColor: Colors.green.shade100,
                onTap: () {
                  // Futuramente: context.push('/transfer');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickActionButton(
                title: 'Receber',
                icon: Icons.call_received,
                iconColor: Colors.orange.shade700,
                backgroundColor: Colors.orange.shade100,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                title: 'Adicionar saldo',
                icon: Icons.add,
                iconColor: Colors.teal.shade700,
                backgroundColor: Colors.teal.shade100,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickActionButton(
                title: 'Pagar',
                icon: Icons.qr_code_scanner,
                iconColor: Colors.deepPurple.shade700,
                backgroundColor: Colors.deepPurple.shade100,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
