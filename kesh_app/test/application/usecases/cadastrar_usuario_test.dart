import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:kesh_app/domain/entities/usuario.dart';
import 'package:kesh_app/domain/entities/carteira.dart';
import 'package:kesh_app/application/usecases/cadastrar_usuario.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';
import 'package:kesh_app/domain/repositories/usuario_repository.dart';
import 'package:kesh_app/domain/services/hash_service.dart';

class MockUsuarioRepository extends Mock implements IUsuarioRepository {}

class MockHashService extends Mock implements IHashService {}

class MockUuid extends Mock implements Uuid {}

class FakeUsuario extends Fake implements Usuario {}

class FakeCarteira extends Fake implements Carteira {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUsuario());
    registerFallbackValue(FakeCarteira());
  });
  late CadastrarUsuario useCase;
  late MockUsuarioRepository repository;
  late MockHashService hashService;
  late MockUuid uuid;

  setUp(() {
    repository = MockUsuarioRepository();
    hashService = MockHashService();
    uuid = MockUuid();
    useCase = CadastrarUsuario(repository, hashService, uuid);

    when(() => uuid.v4()).thenReturn('1234-abcd');
    when(() => hashService.gerarHash(any())).thenReturn('hashed_password');
    when(() => repository.salvarUsuarioECarteira(any(), any()))
        .thenAnswer((_) async {});
  });

  group('CadastrarUsuario Use Case', () {
    test(
      'Deve cadastrar usuário e criar carteira automaticamente com sucesso',
      () async {
        when(() => repository.verificarEmailExistente('joao@email.com'))
            .thenAnswer((_) async => false);
        when(() => repository.verificarCpfExistente('12345678901'))
            .thenAnswer((_) async => false);

        await useCase.executar(
          nomeCompleto: 'João Silva',
          cpf: '12345678901',
          email: 'joao@email.com',
          telefone: '82999999999',
          senhaPlana: 'senhaForte123',
        );

        verify(() => hashService.gerarHash('senhaForte123')).called(1);
        verify(() => repository.salvarUsuarioECarteira(any(), any())).called(1);
      },
    );

    test(
      'Deve lançar EmailJaCadastradoException se e-mail já existir',
      () async {
        when(() => repository.verificarEmailExistente('joao@email.com'))
            .thenAnswer((_) async => true);

        await expectLater(
          useCase.executar(
            nomeCompleto: 'João Silva',
            cpf: '12345678901',
            email: 'joao@email.com',
            telefone: '82999999999',
            senhaPlana: 'senhaForte123',
          ),
          throwsA(isA<EmailJaCadastradoException>()),
        );

        verifyNever(() => repository.salvarUsuarioECarteira(any(), any()));
      },
    );

    test(
      'Deve lançar SenhaFracaException se a senha tiver menos de 6 caracteres',
      () async {
        await expectLater(
          useCase.executar(
            nomeCompleto: 'João Silva',
            cpf: '12345678901',
            email: 'joao@email.com',
            telefone: '82999999999',
            senhaPlana: '123',
          ),
          throwsA(isA<SenhaFracaException>()),
        );
      },
    );
  });
}
