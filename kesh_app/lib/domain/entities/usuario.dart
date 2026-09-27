import '../exceptions/domain_exception.dart';

class Usuario {
  final String id;
  String nomeCompleto;
  final String cpf;
  final String email;
  String telefone;
  String senhaHash;
  final String carteiraId;
  String? chavePagamento;
  bool isBloqueado;

  Usuario({
    required this.id,
    required this.nomeCompleto,
    required this.cpf,
    required this.email,
    required this.telefone,
    required this.senhaHash,
    required this.carteiraId,
    this.chavePagamento,
    this.isBloqueado = false,
  }) {
    _validarDados();
  }

  void _validarDados() {
    if (nomeCompleto.trim().isEmpty) {
      throw DadosInvalidosException('O nome completo é obrigatório.');
    }
    if (!email.contains('@')) {
      throw DadosInvalidosException('E-mail inválido.');
    }
    if (cpf.length < 11) {
      throw DadosInvalidosException('CPF inválido.');
    }
  }

  void editarPerfil({required String novoNome, required String novoTelefone}) {
    if (novoNome.trim().isEmpty || novoTelefone.trim().isEmpty) {
      throw DadosInvalidosException('Nome e telefone não podem ser vazios.');
    }
    nomeCompleto = novoNome;
    telefone = novoTelefone;
  }

  void bloquear() {
    isBloqueado = true;
  }

  void desbloquear() {
    isBloqueado = false;
  }
}
