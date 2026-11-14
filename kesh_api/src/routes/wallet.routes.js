const express = require("express");

const WalletController = require("../controllers/wallet.controller");

const router = express.Router();
const controller = new WalletController();

router.get("/:id", (req, res) => controller.getById(req, res));

router.post("/transfer", (req, res) => controller.transferBalance(req, res));

module.exports = router;
