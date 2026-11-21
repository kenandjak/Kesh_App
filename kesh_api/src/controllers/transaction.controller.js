const TransactionRepository = require("../repositories/transaction.repository");

const transactionRepository = new TransactionRepository();

class TransactionController {
  async getByWalletId(req, res) {
    try {
      const { walletId } = req.params;

      if (!walletId) {
        return res.status(400).json({
          message: "Identificador da carteira obrigatório.",
        });
      }

      const transactions = await transactionRepository.getByWalletId(walletId);

      const formattedTransactions = transactions.map((tx) => ({
        id: tx.id,
        dateTime: tx.created_at,
        type: "transfer",
        amount: Number(tx.amount),
        senderId: tx.sender_wallet_id,
        receiverId: tx.receiver_wallet_id,
        status: "completed",
      }));

      return res.status(200).json({
        transactions: formattedTransactions,
      });
    } catch (error) {
      console.error(error);

      return res.status(500).json({
        message: "Erro ao consultar transações.",
      });
    }
  }
}

module.exports = TransactionController;
