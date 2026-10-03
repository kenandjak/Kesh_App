import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kesh_app/domain/entities/user.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';
import 'package:kesh_app/application/usecases/login_user.dart';
import 'package:kesh_app/domain/repositories/user_repository.dart';
import 'package:kesh_app/domain/services/hash_service.dart';
import 'package:kesh_app/domain/services/token_service.dart';

class MockUsuarioRepository extends Mock implements UserRepository {}

class MockHashService extends Mock implements HashService {}

class MockTokenService extends Mock implements TokenService {}

void main() {
  late LoginUser useCase;
  late MockUsuarioRepository repository;
  late MockHashService hashService;
  late MockTokenService tokenService;
  late User usuarioMock;

  setUp(() {
    repository = MockUsuarioRepository();
    hashService = MockHashService();
    tokenService = MockTokenService();
    useCase = LoginUser(repository, hashService, tokenService);

    usuarioMock = User(
      id: 'USER-123',
      fullName: 'Maria Souza',
      cpf: '12345678901',
      email: 'maria@email.com',
      phone: '911222333',
      passwordHash: 'hash_valida',
      walletId: 'CART-123',
    );
  });

  group('LoginUser Use Case', () {
    test('Deve realizar login e devolver token com sucesso', () async {
      when(() => repository.getByEmail('maria@email.com'))
          .thenAnswer((_) async => usuarioMock);
      when(() => hashService.verifyPassword('senha123', 'hash_valida'))
          .thenReturn(true);
      when(() => tokenService.generateToken(usuarioMock))
          .thenReturn('token_jwt_valido');

      final token = await useCase.execute(
        email: 'maria@email.com',
        plainPassword: 'senha123',
      );

      expect(token, 'token_jwt_valido');
      verify(() => repository.getByEmail('maria@email.com')).called(1);
    });

    test(
      'Deve lançar InvalidCredentialsException se o e-mail não existir',
      () async {
        when(() => repository.getByEmail('desconhecido@email.com'))
            .thenAnswer((_) async => null);

        expect(
          () => useCase.execute(
            email: 'desconhecido@email.com',
            plainPassword: 'senha123',
          ),
          throwsA(isA<InvalidCredentialsException>()),
        );
      },
    );

    test('Deve lançar InvalidCredentialsException se a palavra-passe estiver errada', () async {
      when(() => repository.getByEmail('maria@email.com'))
          .thenAnswer((_) async => usuarioMock);
      when(() => hashService.verifyPassword('senha_errada', 'hash_valida'))
          .thenReturn(false);

      expect(
        () => useCase.execute(
          email: 'maria@email.com',
          plainPassword: 'senha_errada',
        ),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });

    test(
      'Deve lançar UserBlockedException se a conta estiver bloqueada',
      () async {
        usuarioMock.block(); // Bloqueia o usuário

        when(() => repository.getByEmail('maria@email.com'))
            .thenAnswer((_) async => usuarioMock);
        when(() => hashService.verifyPassword('senha123', 'hash_valida'))
            .thenReturn(true);

        expect(
          () => useCase.execute(
            email: 'maria@email.com',
            plainPassword: 'senha123',
          ),
          throwsA(isA<UserBlockedException>()),
        );
      },
    );
  });
}
