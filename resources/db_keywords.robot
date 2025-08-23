*** Settings ***
Documentation     Keywords para interagir com o banco de dados MySQL.

Library           DatabaseLibrary
Library           OperatingSystem
Library           Collections

*** Keywords ***
Carregar Variaveis de Ambiente
    [Documentation]    Carrega as variáveis do arquivo .env para a sessão atual.
    Evaluate          __import__('dotenv').load_dotenv()    dotenv

Conectar ao Banco de Dados
    [Documentation]    Conecta ao DB e cria a tabela de log se não existir.
    Carregar Variaveis de Ambiente

    Log To Console    \nConectando ao banco de dados...
    ${db_host}=       Get Environment Variable    DB_HOST
    ${db_user}=       Get Environment Variable    DB_USER
    ${db_pass}=       Get Environment Variable    DB_PASS
    ${db_name}=       Get Environment Variable    DB_NAME
    ${db_port}=       Get Environment Variable    DB_PORT

    # SINTAXE CORRIGIDA E ATUALIZADA
    Connect To Database
    ...    db_module=pymysql
    ...    db_name=${db_name}
    ...    db_user=${db_user}
    ...    db_password=${db_pass}
    ...    db_host=${db_host}
    ...    db_port=${db_port}

    # Garante que a tabela de execuções existe
    ${table_exists}=    Run Keyword And Return Status    Table Must Exist    test_executions
    IF    not ${table_exists}
        Log To Console    Tabela 'test_executions' não encontrada. Criando...
        Execute Sql String    CREATE TABLE test_executions (id INT AUTO_INCREMENT PRIMARY KEY, test_name VARCHAR(255), status VARCHAR(50), message TEXT, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
    END

Desconectar do Banco de Dados
    [Documentation]    Desconecta da sessão atual do banco de dados.
    Disconnect From Database

Registrar Execução no Banco de Dados
    [Documentation]    Insere o resultado de um teste na tabela 'test_executions'.
    [Arguments]    ${test_name}    ${status}    ${message}
    ${escaped_message}=    Replace String    ${message}    '    \\'  # Escapa aspas simples para evitar erro de SQL
    Execute Sql String    INSERT INTO test_executions (test_name, status, message) VALUES ('${test_name}', '${status}', '${escaped_message}');