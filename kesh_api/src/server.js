require("dotenv").config();

const express = require("express");
const cors = require("cors");

const userRoutes = require("./routes/user.routes");
const walletRoutes = require("./routes/wallet.routes");
const transactionRoutes = require("./routes/transaction.routes");

const app = express();

app.use(
  cors({
    origin: "http://localhost:8080",
  }),
);

app.use(express.json());

app.use("/api/users", userRoutes);
app.use("/api/wallets", walletRoutes);
app.use("/api/transactions", transactionRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`API executando na porta ${PORT}`);
});
