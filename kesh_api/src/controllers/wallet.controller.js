const WalletRepository = require("../repositories/wallet.repository");

const walletRepository = new WalletRepository();

class WalletController {
  async getById(req, res) {
    try {
      const { id } = req.params;

      const wallet = await walletRepository.getById(id);

      if (!wallet) {
        return res.status(404).json({
          message: "Carteira não encontrada",
        });
      }

      return res.status(200).json(wallet);
    } catch (error) {
      console.error(error);

      return res.status(500).json({
        message: "Erro ao consultar carteira",
      });
    }
  }

  async transferBalance(req, res) {
    try {
      const { senderId, receiverId, amount } = req.body;

      if (
        !senderId ||
        !receiverId ||
        senderId === receiverId ||
        amount === undefined ||
        !Number.isFinite(Number(amount)) ||
        Number(amount) <= 0
      ) {
        return res.status(400).json({
          message: "Dados da transferência inválidos",
        });
      }

      await walletRepository.transferBalance(senderId, receiverId, amount);

      return res.status(200).json({
        message: "Transferência realizada com sucesso",
      });
    } catch (error) {
      console.error(error);

      if (
        error.message === "Saldo insuficiente" ||
        error.message.includes("carteiras não existem")
      ) {
        return res.status(400).json({
          message: error.message,
        });
      }

      return res.status(500).json({
        message: "Erro ao realizar transferência",
      });
    }
  }
}

module.exports = WalletController;
