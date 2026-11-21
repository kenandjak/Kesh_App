const pool = require("../config/database");

class TransactionRepository {
  async getByWalletId(walletId) {
    const result = await pool.query(
      `SELECT id, 
      sender_wallet_id, 
      receiver_wallet_id, 
      amount, 
      created_at 
      FROM transfers
      WHERE sender_wallet_id = $1 OR receiver_wallet_id = $1 
      ORDER BY created_at DESC`,
      [walletId],
    );
    return result.rows;
  }
}
module.exports = TransactionRepository;
