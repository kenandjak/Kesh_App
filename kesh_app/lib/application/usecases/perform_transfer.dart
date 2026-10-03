import '../../domain/exceptions/domain_exception.dart';
import '../../domain/repositories/wallet_repository.dart';

// Realizar transferência
class PerformTransfer {
  final WalletRepository _repository;

  PerformTransfer(this._repository);

  Future<void> execute({
    required String senderId,
    required String receiverId,
    required double amount,
  }) async {
    if (senderId == receiverId) {
      throw InvalidTransferException(
        'Remetente e destinatário não podem ser o mesmo usuário.',
      );
    }

    final sender = await _repository.getById(senderId);
    final receiver = await _repository.getById(receiverId);

    if (sender == null || receiver == null) {
      throw InvalidTransferException('Usuário não encontrado.');
    }

    sender.debit(amount);
    receiver.addBalance(amount);

    await _repository.transferBalance(sender, receiver, amount);
  }
}
