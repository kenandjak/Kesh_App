const pool = require("../config/database");

class UserRepository {
  async getById(id) {
    const result = await pool.query(
      `SELECT
        id,
        full_name,
        cpf,
        email,
        phone,
        wallet_id,
        profile_picture,
        created_at
      FROM users
      WHERE id = $1`,
      [id],
    );

    return result.rows[0] || null;
  }

  async getByEmail(email) {
    const result = await pool.query("SELECT * FROM users WHERE email = $1", [
      email,
    ]);

    return result.rows[0] || null;
  }

  async verifyCpf(cpf) {
    const result = await pool.query(
      "SELECT 1 FROM users WHERE cpf = $1 LIMIT 1",
      [cpf],
    );

    return result.rowCount > 0;
  }

  async verifyEmail(email) {
    const result = await pool.query(
      "SELECT 1 FROM users WHERE email = $1 LIMIT 1",
      [email],
    );

    return result.rowCount > 0;
  }
}

module.exports = UserRepository;
