*** Settings ***
Documentation     Suite de testes para a funcionalidade de Checkout.
...               Iniciando com o teste de conexão com o banco de dados.

Resource          ../resources/db_keywords.robot
Resource         ../resources/api_keywords.robot

*** Test Cases ***
[TC-00] Conectar e Desconectar do Banco de Dados com Sucesso
    [Tags]    db    smoke    setup
    [Documentation]    Valida se a conexão com o MySQL está funcionando corretamente.

    Conectar ao Banco de Dados
    Desconectar do Banco de Dados

[TC-01] Criar Novo Usuário Via API com Sucesso
    [Tags]    api    smoke
    [Documentation]    Valida a criação de um novo usuário através da API.

    ${user_data}=    Criar Novo Usuário Via API
    
    # Validações
    Should Not Be Empty    ${user_data}
    Dictionary Should Contain Key    ${user_data}    username
    Dictionary Should Contain Key    ${user_data}    password