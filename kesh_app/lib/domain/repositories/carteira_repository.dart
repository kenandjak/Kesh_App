import '../entities/carteira.dart';

abstract class ICarteiraRepository {
  Future<Carteira?> obterPorId(String id);

  Future<void> transferirSaldo(
    Carteira remetente,
    Carteira destinatario,
    double valor,
  );
}
