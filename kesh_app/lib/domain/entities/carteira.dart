import '../exceptions/domain_exception.dart';

class Carteira {
  final String id;
  double _saldo;

  Carteira({required this.id, double saldoInicial = 0.0})
    : _saldo = saldoInicial;

  double get saldo => _saldo;

  void adicionarSaldo(double valor) {
    if (valor <= 0) throw ValorInvalidoException();
    _saldo += valor;
  }

  void debitar(double valor) {
    if (valor <= 0) throw ValorInvalidoException();
    if (valor > _saldo) throw SaldoInsuficienteException();
    _saldo -= valor;
  }
}
