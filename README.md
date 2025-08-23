# Projeto de Automação de Testes - Advantage Online Shopping

Este projeto contém uma suíte de testes automatizados de ponta a ponta (E2E) para o site [Advantage Online Shopping](https://advantageonlineshopping.com/#/), com foco na funcionalidade de checkout.

O framework utilizado é o **Robot Framework** com **Python**, seguindo as melhores práticas de desenvolvimento, como BDD, organização de keywords e uso de um arquivo de contexto para colaboração com IA.

## Tecnologias Utilizadas

* **Framework:** Robot Framework
* **Linguagem:** Python
* **Bibliotecas Principais:**
    * `robotframework-seleniumlibrary` (Automação Web)
    * `robotframework-requests` (Automação de API)
    * `robotframework-databaselibrary` (Interação com Banco de Dados)
    * `PyMySQL` (Driver de conexão com MySQL)
    * `python-dotenv` (Gerenciamento de variáveis de ambiente)
* **Banco de Dados:** MySQL (gerenciado via XAMPP)
* **Controle de Versão:** Git

## Cobertura dos Testes

Atualmente, a suíte de testes cobre os seguintes cenários:

1.  **Conexão com Banco de Dados:** Validação da comunicação com o MySQL.
2.  **Criação de Massa via API:** Criação de um novo usuário via API antes da execução dos testes de UI.
3.  **Login de Usuário:** Teste E2E que realiza o login na interface web com o usuário criado.
4.  **Adicionar Produto ao Carrinho:** Teste E2E que realiza login, busca um produto, o adiciona ao carrinho e valida sua presença.

## Pré-requisitos

* Python 3.8+
* Git
* XAMPP (ou outro servidor MySQL) com um banco de dados criado (ex: `automation_results`).
* Google Chrome

## Como Configurar o Ambiente

1.  **Clone o repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITÓRIO>
    cd automation-robot
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
    * Crie uma cópia do arquivo `.env.example` (se houver) ou crie um novo arquivo chamado `.env`.
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

* **Executar apenas os testes de login:**
    ```bash
    robot --outputdir results/ --include login testes/
    ```

* **Executar apenas os testes de compra:**
    ```bash
    robot --outputdir results/ --include compra testes/
    ```

* **Executar todos os testes de interface web (login e compra):**
    ```bash
    robot --outputdir results/ --include web testes/
    ```