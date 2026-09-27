import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kesh_app/domain/entities/usuario.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';
import 'package:kesh_app/application/usecases/login_usuario.dart';
import 'package:kesh_app/domain/repositories/usuario_repository.dart';
import 'package:kesh_app/domain/services/hash_service.dart';
import 'package:kesh_app/domain/services/token_service.dart';

class MockUsuarioRepository extends Mock implements IUsuarioRepository {}

class MockHashService extends Mock implements IHashService {}

class MockTokenService extends Mock implements ITokenService {}

void main() {
  late LoginUsuario useCase;
  late MockUsuarioRepository repository;
  late MockHashService hashService;
  late MockTokenService tokenService;
  late Usuario usuarioMock;

  setUp(() {
    repository = MockUsuarioRepository();
    hashService = MockHashService();
    tokenService = MockTokenService();
    useCase = LoginUsuario(repository, hashService, tokenService);

    usuarioMock = Usuario(
      id: 'USER-123',
      nomeCompleto: 'Maria Souza',
      cpf: '12345678901',
      email: 'maria@email.com',
      telefone: '911222333',
      senhaHash: 'hash_valida',
      carteiraId: 'CART-123',
    );
  });

  group('LoginUsuario Use Case', () {
    test('Deve realizar login e devolver token com sucesso', () async {
      when(() => repository.obterPorEmail('maria@email.com'))
          .thenAnswer((_) async => usuarioMock);
      when(() => hashService.verificarSenha('senha123', 'hash_valida'))
          .thenReturn(true);
      when(() => tokenService.gerarToken(usuarioMock))
          .thenReturn('token_jwt_valido');

      final token = await useCase.executar(
        email: 'maria@email.com',
        senhaPlana: 'senha123',
      );

      expect(token, 'token_jwt_valido');
      verify(() => repository.obterPorEmail('maria@email.com')).called(1);
    });

    test(
      'Deve lançar CredenciaisInvalidasException se o e-mail não existir',
      () async {
        when(() => repository.obterPorEmail('desconhecido@email.com'))
            .thenAnswer((_) async => null);

        expect(
          () => useCase.executar(
            email: 'desconhecido@email.com',
            senhaPlana: 'senha123',
          ),
          throwsA(isA<CredenciaisInvalidasException>()),
        );
      },
    );

    test('Deve lançar CredenciaisInvalidasException se a palavra-passe estiver errada', () async {
      when(() => repository.obterPorEmail('maria@email.com'))
          .thenAnswer((_) async => usuarioMock);
      when(() => hashService.verificarSenha('senha_errada', 'hash_valida'))
          .thenReturn(false);

      expect(
        () => useCase.executar(
          email: 'maria@email.com',
          senhaPlana: 'senha_errada',
        ),
        throwsA(isA<CredenciaisInvalidasException>()),
      );
    });

    test(
      'Deve lançar UsuarioBloqueadoException se a conta estiver bloqueada',
      () async {
        usuarioMock.bloquear(); // Bloqueia o utilizador

        when(() => repository.obterPorEmail('maria@email.com'))
            .thenAnswer((_) async => usuarioMock);
        when(() => hashService.verificarSenha('senha123', 'hash_valida'))
            .thenReturn(true);

        expect(
          () => useCase.executar(
            email: 'maria@email.com',
            senhaPlana: 'senha123',
          ),
          throwsA(isA<UsuarioBloqueadoException>()),
        );
      },
    );
  });
}
