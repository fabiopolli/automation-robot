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
│   ├── api_keywords.robot
│   ├── db_keywords.robot
│   ├── common_keywords.robot  (Keywords genéricas de UI e setup do browser)
│   └── pages/                 (Pasta para os Page Objects)
│       ├── home_page.robot
│       ├── product_page.robot
│       └── checkout_page.robot
├── results/
├── testes/
│   └── checkout.robot      (Cenários de teste em Gherkin)
├── .gitignore
├── IA_PROMPT.md
└── requirements.txt

## 4. Regras e Convenções
1.  **Padrão BDD:** Os casos de teste no diretório `/testes` devem ser escritos em Gherkin (Dado, Quando, Então).
2.  **Page Objects:** A interação com elementos web (seletores e keywords) é organizada por página, dentro da pasta `/resources/pages`. Keywords genéricas ficam em `common_keywords.robot`.
3.  **Massa de Dados via API:** Antes de cada teste, uma keyword de `Test Setup` chama a API `/register` para criar um usuário novo e isolado.
4.  **Log em Banco de Dados:** Ao final de cada execução, uma keyword de `Test Teardown` registra o resultado no banco de dados MySQL.
5.  **Evidências:** Screenshots devem ser capturadas em pontos críticos do fluxo.

## 5. Conexão com Banco de Dados (XAMPP)
* **Host:** `localhost`
* **Port:** `3306` (Padrão do MySQL)
* **Usuário:** `root` (Padrão do XAMPP)
* **Senha:** `""` (Vazio, padrão do XAMPP)
* **Database:** `automation_results` (Nome que estamos utilizando)

## 6. Status Atual do Projeto (25/08/2025)
O projeto foi refatorado para o padrão Page Object Model e todos os testes existentes estão passando. A base está estável e organizada.
* **Keywords Implementadas:**
    * `db_keywords.robot`: Conexão e registro de resultados no MySQL.
    * `api_keywords.robot`: Criação de novo usuário via API.
    * `common_keywords.robot`: Keywords genéricas de UI (esperas, cliques, inputs) e setup do browser.
    * `pages/home_page.robot`: Keywords e seletores para Login e Busca.
    * `pages/product_page.robot`: Keywords e seletores para a página de detalhes do produto.
    * `pages/checkout_page.robot`: Keywords e seletores para o fluxo de carrinho e pagamento.
* **Testes Automatizados (Passando):**
    * `[TC-00]`: Validação da conexão com o banco de dados.
    * `[TC-01]`: Validação da criação de usuário via API.
    * `[TC-02]`: Teste E2E de login de usuário.
    * `[TC-03]`: Teste E2E de adição de produto ao carrinho.
    * `[TC-04]`: Teste E2E de compra completa com sucesso.
    * `[TC-05]`: Teste negativo de login com senha incorreta.

## 7. Próximos Passos
Com o fluxo principal e a refatoração concluídos, o próximo objetivo é aumentar a cobertura de testes negativos.
1.  **Adicionar mais Testes Negativos:** Implementar o cenário de busca por um produto inexistente.
2.  **CI/CD:** Configurar a execução dos testes em uma esteira de automação.