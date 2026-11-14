const pool = require("../config/database");

class WalletRepository {
  async getById(id) {
    const result = await pool.query(
      `SELECT id, balance
       FROM wallets
       WHERE id = $1`,
      [id],
    );

    return result.rows[0] || null;
  }

  async transferBalance(senderId, receiverId, amount) {
    const client = await pool.connect();

    try {
      await client.query("BEGIN");

      const result = await client.query(
        `SELECT id, balance
         FROM wallets
         WHERE id IN ($1, $2)
         ORDER BY id
         FOR UPDATE`,
        [senderId, receiverId],
      );

      if (result.rows.length !== 2) {
        throw new Error("Carteiras não encontradas");
      }

      const sender = result.rows.find((wallet) => wallet.id === senderId);

      if (Number(sender.balance) < Number(amount)) {
        throw new Error("Saldo insuficiente");
      }

      await client.query(
        `UPDATE wallets
         SET balance = balance - $1
         WHERE id = $2`,
        [amount, senderId],
      );

      await client.query(
        `UPDATE wallets
         SET balance = balance + $1
         WHERE id = $2`,
        [amount, receiverId],
      );

      await client.query("COMMIT");

      return true;
    } catch (error) {
      await client.query("ROLLBACK");
      throw error;
    } finally {
      client.release();
    }
  }
}

module.exports = WalletRepository;
