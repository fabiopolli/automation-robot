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

## 6. Status Atual do Projeto (25/08/2025)
A base do projeto e o fluxo de compra principal ("happy path") estão implementados e estáveis.
* **Keywords Implementadas:**
    * `db_keywords.robot`: Conexão e registro de resultados no MySQL.
    * `api_keywords.robot`: Criação de novo usuário via API.
    * `web_keywords.robot`: Keywords para o fluxo completo, incluindo login, busca, adição ao carrinho e **finalização de pagamento com SafePay**.
* **Testes Automatizados (Passando):**
    * `[TC-00]`: Validação da conexão com o banco de dados.
    * `[TC-01]`: Validação da criação de usuário via API.
    * `[TC-02]`: Teste E2E de login de usuário.
    * `[TC-03]`: Teste E2E de adição de produto ao carrinho.
    * `[TC-04]`: Teste E2E de **compra completa com sucesso**.

## 7. Próximos Passos
Com o fluxo principal concluído, o próximo objetivo é aumentar a cobertura de testes e preparar o projeto para automação contínua.
1.  **Adicionar Testes Negativos:** Implementar cenários de falha para aumentar a robustez da suíte (ex: login com senha errada, tentativa de pagamento com dados inválidos).
2.  **Refatorar para Page Objects:** Se o projeto crescer, podemos dividir o `web_keywords.robot` em arquivos de Page Objects mais específicos (ex: `home_page.robot`, `payment_page.robot`) para melhorar a manutenção.
3.  **CI/CD:** Configurar a execução dos testes em uma esteira de automação (ex: Jenkins, GitHub Actions).