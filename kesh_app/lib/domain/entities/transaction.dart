import '../exceptions/domain_exception.dart';

enum TransactionType { simulatedDeposit, transfer, payment }

enum TransactionStatus { pending, completed, failed }

class Transaction {
  final String id;
  final DateTime dateTime;
  final TransactionType type;
  final double amount;
  final String? senderId;
  final String receiverId;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.dateTime,
    required this.type,
    required this.amount,
    this.senderId,
    required this.receiverId,
    this.status = TransactionStatus.completed,
  }) {
    if (amount <= 0) {
      throw InvalidAmountException();
    }
    if (type != TransactionType.simulatedDeposit && senderId == null) {
      throw ArgumentError('Transferências e pagamentos exigem um remetente.');
    }
  }
}
