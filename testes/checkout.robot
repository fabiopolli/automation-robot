*** Settings ***
Documentation     Suite de testes para a funcionalidade de Checkout.
...               Iniciando com o teste de conexão com o banco de dados.

Resource          ../resources/db_keywords.robot

*** Test Cases ***
[TC-00] Conectar e Desconectar do Banco de Dados com Sucesso
    [Tags]    db    smoke    setup
    [Documentation]    Valida se a conexão com o MySQL está funcionando corretamente.

    Conectar ao Banco de Dados
    Desconectar do Banco de Dados