// test/domain/entities/usuario_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kesh_app/domain/entities/usuario.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';

void main() {
  group('Usuario | Entity', () {
    test('Deve criar um usuário válido', () {
      final usuario = Usuario(
        id: 'USER-001',
        nomeCompleto: 'João Silva',
        cpf: '12345678901',
        email: 'joao@email.com',
        telefone: '82999999999',
        senhaHash: 'hashed_password_123',
        carteiraId: 'CART-001',
      );

      expect(usuario.nomeCompleto, 'João Silva');
      expect(usuario.isBloqueado, isFalse);
    });

    test('Deve lançar DadosInvalidosException se o email for inválido', () {
      expect(
        () => Usuario(
          id: 'USER-001',
          nomeCompleto: 'João Silva',
          cpf: '12345678901',
          email: 'joao_email.com',
          telefone: '82999999999',
          senhaHash: 'hash',
          carteiraId: 'CART-001',
        ),
        throwsA(isA<DadosInvalidosException>()),
      );
    });

    test('Deve permitir a edição do perfil alterando nome e telefone', () {
      final usuario = Usuario(
        id: 'USER-001',
        nomeCompleto: 'João',
        cpf: '12345678901',
        email: 'joao@email.com',
        telefone: '111',
        senhaHash: 'hash',
        carteiraId: 'CART-001',
      );

      usuario.editarPerfil(novoNome: 'João Silva', novoTelefone: '222');

      expect(usuario.nomeCompleto, 'João Silva');
      expect(usuario.telefone, '222');
    });
  });
}
