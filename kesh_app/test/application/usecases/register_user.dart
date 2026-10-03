import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:kesh_app/domain/entities/user.dart';
import 'package:kesh_app/domain/entities/wallet.dart';
import 'package:kesh_app/application/usecases/register_user.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';
import 'package:kesh_app/domain/repositories/user_repository.dart';
import 'package:kesh_app/domain/services/hash_service.dart';

class MockUsuarioRepository extends Mock implements UserRepository {}

class MockHashService extends Mock implements HashService {}

class MockUuid extends Mock implements Uuid {}

class FakeUsuario extends Fake implements User {}

class FakeCarteira extends Fake implements Wallet {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUsuario());
    registerFallbackValue(FakeCarteira());
  });
  late RegisterUser useCase;
  late MockUsuarioRepository repository;
  late MockHashService hashService;
  late MockUuid uuid;

  setUp(() {
    repository = MockUsuarioRepository();
    hashService = MockHashService();
    uuid = MockUuid();
    useCase = RegisterUser(repository, hashService, uuid);

    when(() => uuid.v4()).thenReturn('1234-abcd');
    when(() => hashService.generateHash(any())).thenReturn('hashed_password');
    when(() => repository.saveUserAndWallet(any(), any()))
        .thenAnswer((_) async {});
  });

  group('RegisterUser Use Case', () {
    test(
      'Deve cadastrar usuário e criar carteira automaticamente com sucesso',
      () async {
        when(() => repository.verifyEmail('joao@email.com'))
            .thenAnswer((_) async => false);
        when(() => repository.verifyCpf('12345678901'))
            .thenAnswer((_) async => false);

        await useCase.execute(
          fullName: 'João Silva',
          cpf: '12345678901',
          email: 'joao@email.com',
          phone: '82999999999',
          plainPassword: 'senhaForte123',
        );

        verify(() => hashService.generateHash('senhaForte123')).called(1);
        verify(() => repository.saveUserAndWallet(any(), any())).called(1);
      },
    );

    test(
      'Deve lançar EmailAlreadyRegisteredException se e-mail já existir',
      () async {
        when(() => repository.verifyEmail('joao@email.com'))
            .thenAnswer((_) async => true);

        await expectLater(
          useCase.execute(
            fullName: 'João Silva',
            cpf: '12345678901',
            email: 'joao@email.com',
            phone: '82999999999',
            plainPassword: 'senhaForte123',
          ),
          throwsA(isA<EmailAlreadyRegisteredException>()),
        );

        verifyNever(() => repository.saveUserAndWallet(any(), any()));
      },
    );

    test('Deve lançar WeakPasswordException se a senha tiver menos de 6 caracteres', () async {
      await expectLater(
        useCase.execute(
          fullName: 'João Silva',
          cpf: '12345678901',
          email: 'joao@email.com',
          phone: '82999999999',
          plainPassword: '123',
        ),
        throwsA(isA<WeakPasswordException>()),
      );
    });
  });
}
