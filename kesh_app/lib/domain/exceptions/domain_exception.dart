abstract class DomainException implements Exception {
  final String mensagem;
  DomainException(this.mensagem);
}

class SaldoInsuficienteException extends DomainException {
  SaldoInsuficienteException() : super('Saldo insuficiente.');
}

class ValorInvalidoException extends DomainException {
  ValorInvalidoException() : super('O valor deve ser maior que zero.');
}

class TransferenciaInvalidaException extends DomainException {
  TransferenciaInvalidaException(super.mensagem);
}

class DadosInvalidosException extends DomainException {
  DadosInvalidosException(super.mensagem);
}

class SenhaFracaException extends DomainException {
  SenhaFracaException() : super('A senha deve ter pelo menos 6 caracteres).');
}

class EmailJaCadastradoException extends DomainException {
  EmailJaCadastradoException() : super('Este e-mail já está em uso.');
}

class CpfJaCadastradoException extends DomainException {
  CpfJaCadastradoException() : super('Este CPF já está em uso.');
}

class CredenciaisInvalidasException extends DomainException {
  CredenciaisInvalidasException()
    : super('E-mail ou palavra-passe incorretos.');
}

class UsuarioBloqueadoException extends DomainException {
  UsuarioBloqueadoException()
    : super('Conta bloqueada. Não é possível aceder ao sistema.');
}
