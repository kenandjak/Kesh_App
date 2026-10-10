abstract class DomainException implements Exception {
  final String mensagem;
  DomainException(this.mensagem);
}

// Saldo insuficiente
class InsufficientBalanceException extends DomainException {
  InsufficientBalanceException() : super('Saldo insuficiente.');
}

// Valor inválido
class InvalidAmountException extends DomainException {
  InvalidAmountException() : super('O valor deve ser maior que zero.');
}

class InvalidTransferException extends DomainException {
  InvalidTransferException(super.mensagem);
}

class InvalidDataException extends DomainException {
  InvalidDataException(super.mensagem);
}

class WeakPasswordException extends DomainException {
  WeakPasswordException() : super('A senha deve ter pelo menos 6 caracteres).');
}

class EmailAlreadyRegisteredException extends DomainException {
  EmailAlreadyRegisteredException() : super('Este e-mail já está em uso.');
}

class CpfAlreadyRegisteredException extends DomainException {
  CpfAlreadyRegisteredException() : super('Este CPF já está em uso.');
}

class InvalidCredentialsException extends DomainException {
  InvalidCredentialsException() : super('E-mail ou palavra-passe incorretos.');
}

class UserBlockedException extends DomainException {
  UserBlockedException()
    : super('Conta bloqueada. Não é possível aceder ao sistema.');
}
