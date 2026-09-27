import '../exceptions/domain_exception.dart';

enum TipoTransacao { depositoSimulado, transferencia, pagamento }

enum StatusTransacao { pendente, concluido, falhado }

class Transacao {
  final String id;
  final DateTime dataHora;
  final TipoTransacao tipo;
  final double valor;
  final String? remetenteId;
  final String destinatarioId;
  final StatusTransacao status;

  Transacao({
    required this.id,
    required this.dataHora,
    required this.tipo,
    required this.valor,
    this.remetenteId,
    required this.destinatarioId,
    this.status = StatusTransacao.concluido,
  }) {
    if (valor <= 0) {
      throw ValorInvalidoException();
    }
    if (tipo != TipoTransacao.depositoSimulado && remetenteId == null) {
      throw ArgumentError('Transferências e pagamentos exigem um remetente.');
    }
  }
}
