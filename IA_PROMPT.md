# Contexto do Projeto: Automação de Testes Advantage Shopping

## 1. Objetivo Geral
[cite_start]O objetivo deste projeto é desenvolver uma suíte de testes automatizados para a funcionalidade de "checkout" do site https://advantageonlineshopping.com/#/.  A automação deve cobrir o fluxo web, utilizar a API para preparação de dados e registrar os resultados em um banco de dados.

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
├── tests/
│   └── checkout.robot      (Cenários de teste em Gherkin)
├── .gitignore
├── IA_PROMPT.md
└── requirements.txt

## 4. Regras e Convenções
1.  [cite_start]**Padrão BDD:** Os casos de teste no diretório `/tests` devem ser escritos em Gherkin (Dado, Quando, Então). [cite: 83]
2.  [cite_start]**Page Objects:** A interação com elementos web (seletores, cliques, inputs) deve ser abstraída em keywords dentro de `web_keywords.robot`. 
3.  [cite_start]**Massa de Dados via API:** Antes de cada teste de UI que necessite de um usuário, uma keyword deve chamar a API `/register` para criar um usuário novo e isolado. 
4.  [cite_start]**Log em Banco de Dados:** Ao final de cada execução de teste, uma keyword de Teardown deve registrar o resultado (nome do teste, status, mensagem) em uma tabela no banco de dados MySQL. [cite: 97]
5.  [cite_start]**Evidências:** Screenshots devem ser capturadas em pontos críticos do fluxo. [cite: 94]

## 5. Conexão com Banco de Dados (XAMPP)
* **Host:** `localhost`
* **Port:** `3306` (Padrão do MySQL)
* **Usuário:** `root` (Padrão do XAMPP)
* **Senha:** `""` (Vazio, padrão do XAMPP)
* **Database:** `automation_challenge` (Sugestão de nome)