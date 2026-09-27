import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kesh_app/domain/entities/carteira.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';
import 'package:kesh_app/domain/repositories/carteira_repository.dart';
import 'package:kesh_app/application/usecases/realizar_transferencia.dart';

class MockCarteiraRepository extends Mock implements ICarteiraRepository {}

class FakeCarteira extends Fake implements Carteira {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCarteira());
  });

  late RealizarTransferencia useCase;
  late MockCarteiraRepository repository;

  setUp(() {
    repository = MockCarteiraRepository();
    useCase = RealizarTransferencia(repository);
  });

  group('Realizar Transferencia | Use Case', () {
    test(
      'Deve transferir o saldo corretamente mantendo a consistência',
      () async {
        // Arrange
        final carteiraRemetente = Carteira(id: 'USER-A', saldoInicial: 100.0);
        final carteiraDestinatario = Carteira(
          id: 'USER-B',
          saldoInicial: 200.0,
        );

        when(() => repository.obterPorId('USER-A'))
            .thenAnswer((_) async => carteiraRemetente);
        when(() => repository.obterPorId('USER-B'))
            .thenAnswer((_) async => carteiraDestinatario);
        when(() => repository.transferirSaldo(any(), any(), any()))
            .thenAnswer((_) async => Future.value());

        // Act
        await useCase.executar(
          idRemetente: 'USER-A',
          idDestinatario: 'USER-B',
          valor: 50.0,
        );

        // Assert
        expect(carteiraRemetente.saldo, 50.0);
        expect(carteiraDestinatario.saldo, 250.0);
        verify(
          () => repository.transferirSaldo(
            carteiraRemetente,
            carteiraDestinatario,
            50.0,
          ),
        ).called(1);
      },
    );

    test('Deve falhar se o remetente tentar pagar a si mesmo', () async {
      // Act & Assert
      await expectLater(
        useCase.executar(
          idRemetente: 'USER-A',
          idDestinatario: 'USER-A',
          valor: 50.0,
        ),
        throwsA(isA<TransferenciaInvalidaException>()),
      );
    });

    test(
      'Deve falhar por saldo insuficiente e não chamar o repositório',
      () async {
        // Arrange
        final carteiraRemetente = Carteira(id: 'USER-A', saldoInicial: 100.0);
        final carteiraDestinatario = Carteira(
          id: 'USER-B',
          saldoInicial: 200.0,
        );

        when(() => repository.obterPorId('USER-A'))
            .thenAnswer((_) async => carteiraRemetente);
        when(() => repository.obterPorId('USER-B'))
            .thenAnswer((_) async => carteiraDestinatario);

        // Act & Assert
        await expectLater(
          useCase.executar(
            idRemetente: 'USER-A',
            idDestinatario: 'USER-B',
            valor: 150.0,
          ),
          throwsA(isA<SaldoInsuficienteException>()),
        );

        verifyNever(() => repository.transferirSaldo(any(), any(), any()));
      },
    );
  });
}
