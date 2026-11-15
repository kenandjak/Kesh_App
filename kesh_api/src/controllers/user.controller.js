const UserRepository = require("../repositories/user.repository");

const userRepository = new UserRepository();

class UserController {
  async getById(req, res) {
    try {
      const { id } = req.params;

      const user = await userRepository.getById(id);

      if (!user) {
        return res.status(404).json({
          message: "Usuário não encontrado",
        });
      }

      const { password_hash, ...safeUser } = user;

      return res.status(200).json(safeUser);
    } catch (error) {
      console.error(error);

      return res.status(500).json({
        message: "Erro ao consultar usuário",
      });
    }
  }
}

module.exports = UserController;
