// test/domain/entities/usuario_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kesh_app/domain/entities/user.dart';
import 'package:kesh_app/domain/exceptions/domain_exception.dart';

void main() {
  group('User | Entity', () {
    test('Deve criar um usuário válido', () {
      final usuario = User(
        id: 'USER-001',
        fullName: 'João Silva',
        cpf: '12345678901',
        email: 'joao@email.com',
        phone: '82999999999',
        passwordHash: 'hashed_password_123',
        walletId: 'CART-001',
      );

      expect(usuario.fullName, 'João Silva');
      expect(usuario.isBlocked, isFalse);
    });

    test('Deve lançar InvalidDataException se o email for inválido', () {
      expect(
        () => User(
          id: 'USER-001',
          fullName: 'João Silva',
          cpf: '12345678901',
          email: 'joao_email.com',
          phone: '82999999999',
          passwordHash: 'hash',
          walletId: 'CART-001',
        ),
        throwsA(isA<InvalidDataException>()),
      );
    });

    test('Deve permitir a edição do perfil alterando nome e telefone', () {
      final usuario = User(
        id: 'USER-001',
        fullName: 'João',
        cpf: '12345678901',
        email: 'joao@email.com',
        phone: '111',
        passwordHash: 'hash',
        walletId: 'CART-001',
      );

      usuario.editProfile(newName: 'João Silva', newPhone: '222');

      expect(usuario.fullName, 'João Silva');
      expect(usuario.phone, '222');
    });
  });
}
