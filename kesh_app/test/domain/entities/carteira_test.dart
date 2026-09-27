// test/domain/entities/carteira_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kesh_app/domain/entities/carteira.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';

void main() {
  group('Carteira | Entity', () {
    test('Deve adicionar saldo corretamente', () {
      final carteira = Carteira(id: 'USER-123', saldoInicial: 200.0);

      carteira.adicionarSaldo(100.0);

      expect(carteira.saldo, 300.0);
    });

    test('Deve lançar SaldoInsuficienteException ao debitar valor maior que o saldo', () {
      final carteira = Carteira(id: 'USER-123', saldoInicial: 100.0);

      expect(
        () => carteira.debitar(150.0),
        throwsA(isA<SaldoInsuficienteException>()),
      );
    });

    test('Deve lançar ValorInvalidoException ao tentar debitar um valor menor ou igual a zero', () {
      final carteira = Carteira(id: 'USER-123', saldoInicial: 100.0);

      expect(
        () => carteira.debitar(-50.0),
        throwsA(isA<ValorInvalidoException>()),
      );
    });
  });
}
