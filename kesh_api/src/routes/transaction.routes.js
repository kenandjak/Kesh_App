const express = require("express");
const TransactionController = require("../controllers/transaction.controller");

const router = express.Router();

const controller = new TransactionController();

router.get("/wallet/:walletId", (req, res) =>
  controller.getByWalletId(req, res),
);

module.exports = router;
