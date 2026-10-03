import '../exceptions/domain_exception.dart';

class Wallet {
  final String id;
  double _balance; // saldo

  Wallet({required this.id, double initialBalance = 0.0})
    : _balance = initialBalance;

  double get balance => _balance;
  // add ao saldo o valor
  void addBalance(double amount) {
    if (amount <= 0) throw InvalidAmountException();
    _balance += amount;
  }

  void debit(double amount) {
    if (amount <= 0) throw InvalidAmountException();
    if (amount > _balance) throw InsufficientBalanceException();
    _balance -= amount;
  }
}
