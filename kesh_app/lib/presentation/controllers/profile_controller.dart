import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ProfileController extends ChangeNotifier {
  bool isLoading = false;

  final String fullName = 'Mickey Mouse Mosca';
  final String shortName = 'Mickey Mouse';
  final String email = 'mickey@disney.com';
  final String phone = '(11) 99999-9999';
  final String walletId = 'KSH-039284';
  final String memberSince = 'maio de 2026';

  String get currentDateFormatted {
    final now = DateTime.now();
    final formatter = DateFormat("EEEE, d 'DE' MMMM", 'pt_BR');
    return formatter.format(now).toUpperCase();
  }

  // Iniciais para o Avatar
  String get initials {
    final parts = shortName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return shortName[0].toUpperCase();
  }
}
