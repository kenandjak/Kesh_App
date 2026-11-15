import 'package:flutter/foundation.dart';

import '../../application/usecases/perform_transfer.dart';

class TransferController extends ChangeNotifier {
  final PerformTransfer _performTransfer;

  TransferController(this._performTransfer);

  bool isLoading = false;
  bool success = false;
  String? errorMessage;

  Future<bool> transfer({
    required String senderId,
    required String receiverId,
    required double amount,
  }) async {
    isLoading = true;
    success = false;
    errorMessage = null;

    notifyListeners();

    try {
      await _performTransfer.execute(
        senderId: senderId,
        receiverId: receiverId,
        amount: amount,
      );

      success = true;
      return true;
    } catch (e, st) {
      debugPrint('Erro na transferência: $e\n$st');

      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
