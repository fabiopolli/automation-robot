# Contexto do Projeto: Automação de Testes Advantage Shopping

## 1. Objetivo Geral
O objetivo deste projeto é desenvolver uma suíte de testes automatizados para a funcionalidade de "checkout" do site https://advantageonlineshopping.com/#/. A automação deve cobrir o fluxo web, utilizar a API para preparação de dados e registrar os resultados em um banco de dados.

## 2. Stack de Tecnologias
* **Framework:** Robot Framework
* **Linguagem:** Python
* **Bibliotecas Robot:**
    * `SeleniumLibrary` (Web UI)
    * `RequestsLibrary` (API)
    * `DatabaseLibrary` (Banco de Dados)
* **Banco de Dados:** MySQL (gerenciado via XAMPP)
* **Driver DB:** `PyMySQL`

## 3. Estrutura de Arquivos
/
├── libs/
├── resources/
│   ├── api_keywords.robot  (Keywords para interagir com a API REST)
│   ├── db_keywords.robot   (Keywords para conectar e manipular o BD)
│   └── web_keywords.robot  (Keywords de UI, Page Objects, etc.)
├── results/
├── testes/
│   └── checkout.robot      (Cenários de teste em Gherkin)
├── .gitignore
├── IA_PROMPT.md
└── requirements.txt

## 4. Regras e Convenções
1.  **Padrão BDD:** Os casos de teste no diretório `/testes` devem ser escritos em Gherkin (Dado, Quando, Então).
2.  **Page Objects:** A interação com elementos web (seletores, cliques, inputs) deve ser abstraída em keywords dentro de `web_keywords.robot`.
3.  **Massa de Dados via API:** Antes de cada teste de UI que necessite de um usuário, uma keyword deve chamar a API `/register` para criar um usuário novo e isolado.
4.  **Log em Banco de Dados:** Ao final de cada execução de teste, uma keyword de Teardown deve registrar o resultado (nome do teste, status, mensagem) em uma tabela no banco de dados MySQL.
5.  **Evidências:** Screenshots devem ser capturadas em pontos críticos do fluxo.

## 5. Conexão com Banco de Dados (XAMPP)
* **Host:** `localhost`
* **Port:** `3306` (Padrão do MySQL)
* **Usuário:** `root` (Padrão do XAMPP)
* **Senha:** `""` (Vazio, padrão do XAMPP)
* **Database:** `automation_results` (Nome que estamos utilizando)

## 6. Status Atual do Projeto (22/08/2025)
A base do projeto está implementada e estável.
* **Keywords Implementadas:**
    * `db_keywords.robot`: Conexão e registro de resultados no MySQL.
    * `api_keywords.robot`: Criação de novo usuário via API.
    * `web_keywords.robot`: Login, tratamento de pop-up, busca de produto e adição ao carrinho.
* **Testes Automatizados (Passando):**
    * `[TC-00]`: Validação da conexão com o banco de dados.
    * `[TC-01]`: Validação da criação de usuário via API.
    * `[TC-02]`: Teste E2E de login de usuário.
    * `[TC-03]`: Teste E2E de adição de produto ao carrinho.

## 7. Próximos Passos
O próximo objetivo é continuar o fluxo de checkout a partir do carrinho de compras.
1.  **Implementar Keywords de Checkout:** Criar keywords em `web_keywords.robot` para:
    * Clicar no botão de checkout no carrinho.
    * Preencher os dados de pagamento (SafePay).
    * Validar a mensagem de "Thank you for your order".
2.  **Criar o Teste de Compra Completa:** Adicionar um novo caso de teste `[TC-04]` para o fluxo completo.
3.  **Adicionar Testes Negativos:** Implementar cenários de falha (ex: login com senha errada).
4.  **CI/CD:** Configurar a execução dos testes em uma esteira de automação.