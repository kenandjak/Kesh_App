import 'package:flutter_test/flutter_test.dart';
import 'package:kesh_app/domain/entities/transacao.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';

void main() {
  group('Transacao | Entity', () {
    test('Deve criar uma transação de depósito simulado sem remetente', () {
      final transacao = Transacao(
        id: 'TXN-001',
        dataHora: DateTime.now(),
        tipo: TipoTransacao.depositoSimulado,
        valor: 100.0,
        destinatarioId: 'USER-123',
      );

      expect(transacao.id, 'TXN-001');
      expect(transacao.valor, 100.0);
      expect(transacao.tipo, TipoTransacao.depositoSimulado);
      expect(transacao.remetenteId, isNull);
    });

    test('Deve criar uma transação de transferência com sucesso', () {
      final transacao = Transacao(
        id: 'TXN-002',
        dataHora: DateTime.now(),
        tipo: TipoTransacao.transferencia,
        valor: 50.0,
        remetenteId: 'USER-001',
        destinatarioId: 'USER-123',
      );

      expect(transacao.id, 'TXN-002');
      expect(transacao.remetenteId, 'USER-001');
      expect(transacao.destinatarioId, 'USER-123');
    });

    test(
      'Deve lançar ValorInvalidoException se o valor for zero ou negativo',
      () {
        expect(
          () => Transacao(
            id: 'TXN-003',
            dataHora: DateTime.now(),
            tipo: TipoTransacao.pagamento,
            valor: 0.0,
            remetenteId: 'USER-001',
            destinatarioId: 'USER-123',
          ),
          throwsA(isA<ValorInvalidoException>()),
        );
      },
    );

    test('Deve lançar ArgumentError se uma transferência ou pagamento não possuir remetente', () {
      expect(
        () => Transacao(
          id: 'TXN-004',
          dataHora: DateTime.now(),
          tipo: TipoTransacao.transferencia,
          valor: 50.0,
          destinatarioId: 'USER-123', // remetenteId omitido propositadamente
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
