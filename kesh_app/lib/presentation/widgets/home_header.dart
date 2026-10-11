import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    required this.formattedDate,
    this.onNotificationsTap,
  });

  final String userName;
  final String formattedDate;
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Olá, $userName.',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                ),
                onPressed: onNotificationsTap,
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: const Color(0xFFD6F399),
              foregroundColor: Colors.green.shade900,
              child: Text(
                userName.isNotEmpty ? userName[0] : '?',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
