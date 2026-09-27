# Kesh - Sistema de Pagamentos Digitais

Aplicativo de carteira digital e transferências financeiras simplificado, desenvolvido como requisito para a disciplina de Engenharia de Software para Dispositivos Móveis no curso de Ciência da Computação da Universidade Federal de Alagoas (UFAL).

## Visão Geral

O Kesh é um MVP construído para simular operações financeiras garantindo a integridade dos dados e aplicando boas práticas de engenharia de software. O sistema permite aos usuários criar uma conta, realizar login, possuir uma carteira digital e adicionar saldo de forma simulada. Além disso, os usuários podem transferir saldo para outros usuários, receber transferências, realizar pagamentos, consultar extrato e gerar um QR Code para recebimento.

## Arquitetura e Padrões

O projeto foi estruturado utilizando **Arquitetura Hexagonal (Clean Architecture)** e princípios **SOLID**, visando o isolamento das regras de negócio (Domínio) em relação às ferramentas de interface (Flutter) e persistência de dados.

- **Test-Driven Development (TDD):** Regras de negócio e consistência financeira validadas com `flutter_test` e `mocktail`.
- **Injeção de Dependências:** Gerenciamento de instâncias e inversão de controle utilizando o pacote `get_it`.
- **Integridade Atômica:** Garantia de consistência no saldo das carteiras através de transações de banco de dados (`commit`/`rollback`).

## Funcionalidades do MVP

- **Gestão de Usuários:** Cadastro, login, logout e edição de perfil.
- **Carteira:** Visualização de saldo e adição de valores via depósito simulado.
- **Transferências e Pagamentos:** Enviar e receber dinheiro entre usuários do sistema, além de simular pagamento.
- **Extrato:** Consulta ao histórico de transações com detalhes de data, horário, tipo, valor, remetente/destinatário e status.
- **Identificação:** Cadastro de chave de usuário e geração de QR Code para recebimento.

## Como Executar

**Pré-requisitos:**

- Flutter SDK configurado (versão mais recente recomendada).
- Dispositivo físico ou emulador (Android/iOS) - opcional.

**Passos:**

1. Clone este repositório:
   ```bash
   git clone https://github.com/kenandjak/Kesh_App.git
   ```
2. Instale as dependências:

   ```bash
   flutter pub get
   ```

3. Execute os testes unitários de domínio e aplicação:

   ```bash
   flutter test
   ```

4. Inicie o aplicativo:

   ```bash
   flutter run
   ```
