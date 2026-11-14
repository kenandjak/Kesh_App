const express = require("express");
const UserController = require("../controllers/user.controller");

const router = express.Router();
const controller = new UserController();

router.get("/:id", (req, res) => controller.getById(req, res));

module.exports = router;
