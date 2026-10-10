// test/domain/entities/carteira_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kesh_app/domain/entities/wallet.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';

void main() {
  group('Wallet | Entity', () {
    test('Deve adicionar balance corretamente', () {
      final carteira = Wallet(id: 'USER-123', initialBalance: 200.0);

      carteira.addBalance(100.0);

      expect(carteira.balance, 300.0);
    });

    test('Deve lançar InsufficientBalanceException ao debitar valor maior que o saldo', () {
      final carteira = Wallet(id: 'USER-123', initialBalance: 100.0);

      expect(
        () => carteira.debit(150.0),
        throwsA(isA<InsufficientBalanceException>()),
      );
    });

    test('Deve lançar InvalidAmountException ao tentar debitar um valor menor ou igual a zero', () {
      final carteira = Wallet(id: 'USER-123', initialBalance: 100.0);

      expect(
        () => carteira.debit(-50.0),
        throwsA(isA<InvalidAmountException>()),
      );
    });
  });
}
