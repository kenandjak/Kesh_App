CREATE TABLE wallets (
    id VARCHAR(50) PRIMARY KEY,
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    profile_picture TEXT,
    wallet_id VARCHAR(50) REFERENCES wallets(id)
);

INSERT INTO wallets (id, balance) VALUES 
('KSH-039284', 2840.65),
('KSH-112233', 150.00),
('KSH-998877', 5900.00);

INSERT INTO users (id, full_name, cpf, email, password_hash, phone, profile_picture, wallet_id) VALUES 
('USR-001', 'Mickey Mouse Mosca', '111.111.111-11', 'mickey@disney.com', '123456', '(11) 98765-4321', NULL, 'KSH-039284'),
('USR-002', 'Frodo Bolseiro', '222.222.222-22', 'frodo@email.com', '123456', '(11) 99999-2222', NULL, 'KSH-112233'),
('USR-003', 'Ashley Banks', '333.333.333-33', 'ashley@belair.com', '111111', '(11) 98888-3333', NULL, 'KSH-998877');