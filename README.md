# Projeto de Automação de Testes - Advantage Online Shopping

Este projeto contém uma suíte de testes automatizados de ponta a ponta (E2E) para o site [Advantage Online Shopping](https://advantageonlineshopping.com/#/), com foco na funcionalidade de checkout.

O framework utilizado é o **Robot Framework** com **Python**, seguindo as melhores práticas de desenvolvimento, como BDD, o padrão Page Object Model (POM) e uso de um arquivo de contexto para colaboração com IA.

## Tecnologias Utilizadas

* **Framework:** Robot Framework
* **Linguagem:** Python
* **Bibliotecas Principais:**
    * `robotframework-seleniumlibrary` (Automação Web)
    * `robotframework-requests` (Automação de API)
    * `robotframework-databaselibrary` (Interação com Banco de Dados)
    * `PyMySQL` (Driver de conexão com MySQL)
    * `python-dotenv` (Gerenciamento de variáveis de ambiente)
    * `cryptography` (Dependência para autenticação segura com MySQL 8+)
* **Banco de Dados:** MySQL (gerenciado via XAMPP)
* **Controle de Versão:** Git & GitHub
* **CI/CD:** GitHub Actions

## Cobertura dos Testes

Atualmente, a suíte de testes cobre os seguintes cenários:

#### Testes Positivos ("Caminho Feliz")
1.  **Conexão com Banco de Dados (`[TC-00]`):** Validação da comunicação com o MySQL.
2.  **Criação de Massa via API (`[TC-01]`):** Validação da criação de um novo usuário via API.
3.  **Login de Usuário (`[TC-02]`):** Teste E2E que realiza o login na interface web.
4.  **Adicionar Produto ao Carrinho (`[TC-03]`):** Teste E2E que realiza login, busca por um produto e o adiciona ao carrinho.
5.  **Compra Completa com Sucesso (`[TC-04]`):** Teste E2E que valida o fluxo completo de compra até a mensagem de sucesso.

#### Testes Negativos
1.  **Login com Senha Incorreta (`[TC-05]`):** Valida se o sistema exibe uma mensagem de erro ao usar uma senha incorreta.
2.  **Busca por Produto Inexistente (`[TC-06]`):** Valida se o sistema exibe a mensagem correta quando um produto não é encontrado.

## Pré-requisitos

* Python 3.8+
* Git
* XAMPP (ou outro servidor MySQL) com um banco de dados criado (ex: `automation_results`).
* Google Chrome

## Como Configurar o Ambiente

1.  **Clone o repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITÓRIO>
    cd <NOME_DA_PASTA_DO_PROJETO>
    ```

2.  **Crie e ative um ambiente virtual:**
    ```bash
    # Criar
    python -m venv venv
    # Ativar (Windows)
    .\venv\Scripts\activate
    # Ativar (Mac/Linux)
    source venv/bin/activate
    ```

3.  **Instale as dependências:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Configure as variáveis de ambiente:**
    * Crie um arquivo chamado `.env` na raiz do projeto.
    * Preencha as variáveis conforme o exemplo abaixo:
        ```ini
        SITE_URL=[https://advantageonlineshopping.com/#/](https://advantageonlineshopping.com/#/)
        BROWSER=chrome
        DB_HOST=localhost
        DB_PORT=3306
        DB_NAME=automation_results
        DB_USER=root
        DB_PASS=
        ```

## Como Executar os Testes

Use os seguintes comandos na raiz do projeto para executar os testes. Os resultados serão gerados na pasta `/results`.

* **Executar todos os testes:**
    ```bash
    robot --outputdir results/ testes/
    ```

* **Executar um grupo de testes por tag (ex: todos os de `compra` e `pagamento`):**
    ```bash
    robot --outputdir results/ --include compraORpagamento testes/
    ```

* **Executar um único teste pelo nome (ex: o de compra completa):**
    ```bash
    robot --outputdir results/ --test "[TC-04] Realizar Compra Completa com Sucesso" testes/
    ```
## Execução via CI/CD (GitHub Actions)

Este projeto está configurado para executar todos os testes automaticamente a cada `push` ou `pull request` para a branch `main`. Os resultados podem ser visualizados na aba "Actions" do repositório no GitHub.

[Testes Report.pdf](https://github.com/user-attachments/files/21962587/Testes.Report.pdf)
