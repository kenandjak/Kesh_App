import '../exceptions/domain_exception.dart';

class User {
  final String id;
  String fullName;
  final String cpf;
  final String email;
  String phone;
  String passwordHash;
  final String walletId;
  String? paymentKey;
  bool isBlocked;

  User({
    required this.id,
    required this.fullName,
    required this.cpf,
    required this.email,
    required this.phone,
    required this.passwordHash,
    required this.walletId,
    this.paymentKey,
    this.isBlocked = false,
  }) {
    _validateData();
  }

  void _validateData() {
    if (fullName.trim().isEmpty) {
      throw InvalidDataException('O nome completo é obrigatório.');
    }
    if (!email.contains('@')) {
      throw InvalidDataException('Email inválido.');
    }
    if (cpf.length < 11) {
      throw InvalidDataException('CPF inválido.');
    }
  }

  void editProfile({required String newName, required String newPhone}) {
    if (newName.trim().isEmpty || newPhone.trim().isEmpty) {
      throw InvalidDataException('Nome e telefone não podem estar vazios.');
    }
    fullName = newName;
    phone = newPhone;
  }

  void block() {
    isBlocked = true;
  }

  void unblock() {
    isBlocked = false;
  }
}
