import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kesh_app/domain/entities/wallet.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';
import 'package:kesh_app/domain/repositories/wallet_repository.dart';
import 'package:kesh_app/application/usecases/perform_transfer.dart';

class MockCarteiraRepository extends Mock implements WalletRepository {}

class FakeCarteira extends Fake implements Wallet {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCarteira());
  });

  late PerformTransfer useCase;
  late MockCarteiraRepository repository;

  setUp(() {
    repository = MockCarteiraRepository();
    useCase = PerformTransfer(repository);
  });

  group('Realizar Transferencia | Use Case', () {
    test(
      'Deve transferir o balance corretamente mantendo a consistência',
      () async {
        // Arrange
        final walletSender = Wallet(id: 'USER-A', initialBalance: 100.0);
        final walletReceiver = Wallet(id: 'USER-B', initialBalance: 200.0);

        when(() => repository.getById('USER-A'))
            .thenAnswer((_) async => walletSender);
        when(() => repository.getById('USER-B'))
            .thenAnswer((_) async => walletReceiver);
        when(() => repository.transferBalance(any(), any(), any()))
            .thenAnswer((_) async => Future.value());

        // Act
        await useCase.execute(
          senderId: 'USER-A',
          receiverId: 'USER-B',
          amount: 50.0,
        );

        // Assert
        expect(walletSender.balance, 50.0);
        expect(walletReceiver.balance, 250.0);
        verify(
          () => repository.transferBalance(walletSender, walletReceiver, 50.0),
        ).called(1);
      },
    );

    test('Deve falhar se o remetente tentar pagar a si mesmo', () async {
      // Act & Assert
      await expectLater(
        useCase.execute(senderId: 'USER-A', receiverId: 'USER-A', amount: 50.0),
        throwsA(isA<InvalidTransferException>()),
      );
    });

    test(
      'Deve falhar por balance insuficiente e não chamar o repositório',
      () async {
        // Arrange
        final walletSender = Wallet(id: 'USER-A', initialBalance: 100.0);
        final walletReceiver = Wallet(id: 'USER-B', initialBalance: 200.0);

        when(() => repository.getById('USER-A'))
            .thenAnswer((_) async => walletSender);
        when(() => repository.getById('USER-B'))
            .thenAnswer((_) async => walletReceiver);

        // Act & Assert
        await expectLater(
          useCase.execute(
            senderId: 'USER-A',
            receiverId: 'USER-B',
            amount: 150.0,
          ),
          throwsA(isA<InsufficientBalanceException>()),
        );

        verifyNever(() => repository.transferBalance(any(), any(), any()));
      },
    );
  });
}
