import 'package:flutter_test/flutter_test.dart';
import 'package:kesh_app/domain/entities/transaction.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';

void main() {
  group('Transaction | Entity', () {
    test('Deve criar uma transação de depósito simulado sem remetente', () {
      final transacao = Transaction(
        id: 'TXN-001',
        dateTime: DateTime.now(),
        type: TransactionType.simulatedDeposit,
        amount: 100.0,
        receiverId: 'USER-123',
      );

      expect(transacao.id, 'TXN-001');
      expect(transacao.amount, 100.0);
      expect(transacao.type, TransactionType.simulatedDeposit);
      expect(transacao.senderId, isNull);
    });

    test('Deve criar uma transação de transferência com sucesso', () {
      final transacao = Transaction(
        id: 'TXN-002',
        dateTime: DateTime.now(),
        type: TransactionType.transfer,
        amount: 50.0,
        senderId: 'USER-001',
        receiverId: 'USER-123',
      );

      expect(transacao.id, 'TXN-002');
      expect(transacao.senderId, 'USER-001');
      expect(transacao.receiverId, 'USER-123');
    });

    test(
      'Deve lançar InvalidAmountException se o valor for zero ou negativo',
      () {
        expect(
          () => Transaction(
            id: 'TXN-003',
            dateTime: DateTime.now(),
            type: TransactionType.payment,
            amount: 0.0,
            senderId: 'USER-001',
            receiverId: 'USER-123',
          ),
          throwsA(isA<InvalidAmountException>()),
        );
      },
    );

    test('Deve lançar ArgumentError se uma transferência ou payment não possuir remetente', () {
      expect(
        () => Transaction(
          id: 'TXN-004',
          dateTime: DateTime.now(),
          type: TransactionType.transfer,
          amount: 50.0,
          receiverId: 'USER-123', // senderId omitido propositadamente
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
