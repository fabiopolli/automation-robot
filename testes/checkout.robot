*** Settings ***
Documentation     Suite de testes para a funcionalidade de Checkout.
Resource          ../resources/db_keywords.robot
Resource          ../resources/api_keywords.robot
Resource          ../resources/web_keywords.robot

Test Setup        Setup do Teste de Checkout
Test Teardown     Teardown do Teste de Checkout

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
    Should Not Be Empty    ${user_data}
    Dictionary Should Contain Key    ${user_data}    username
    Dictionary Should Contain Key    ${user_data}    password

[TC-02] Fazer Login de Usuário com Sucesso
    [Tags]    web    smoke    login
    [Documentation]    Valida o fluxo de ponta a ponta: API -> Login Web -> DB.
    
    Dado que acesso a página principal do site
    Quando insiro minhas credenciais de login
    Então o login deve ser realizado com sucesso

[TC-03] Adicionar Produto ao Carrinho com Sucesso
    [Tags]    web    compra
    [Documentation]    Valida o fluxo de busca e adição de um produto ao carrinho.

    Dado que estou logado no sistema
    Quando eu busco por um produto e o adiciono ao carrinho
    Então o produto deve ser exibido corretamente no carrinho

*** Keywords ***
Setup do Teste de Checkout
    [Documentation]    Prepara o ambiente para um teste: cria usuário e conecta ao DB.
    Conectar ao Banco de Dados
    ${user_info}=    Criar Novo Usuário Via API
    Set Test Variable    ${USER_CREDENTIALS}    ${user_info}

Teardown do Teste de Checkout
    [Documentation]    Limpa o ambiente: registra resultado, fecha navegador e desconecta do DB.
    ${test_message}=    Run Keyword And Return Status    Get Variable Value    ${TEST_MESSAGE}
    Run Keyword And Ignore Error    Registrar Execução no Banco de Dados    ${TEST_NAME}    ${TEST_STATUS}    ${test_message}
    Run Keyword And Ignore Error    Close Browser
    Desconectar do Banco de Dados

Dado que acesso a página principal do site
    Abrir Navegador e Acessar a Página Principal

Quando insiro minhas credenciais de login
    ${username}=    Set Variable    ${USER_CREDENTIALS}[username]
    ${password}=    Set Variable    ${USER_CREDENTIALS}[password]
    Fazer Login Pela Interface    ${username}    ${password}

Então o login deve ser realizado com sucesso
    ${username}=    Set Variable    ${USER_CREDENTIALS}[username]
    Verificar Login Bem Sucedido    ${username}

Dado que estou logado no sistema
    # --- CORREÇÃO APLICADA AQUI ---
    Abrir Navegador e Acessar a Página Principal
    Fazer Login Pela Interface    ${USER_CREDENTIALS.username}    ${USER_CREDENTIALS.password}
    Verificar Login Bem Sucedido    ${USER_CREDENTIALS.username}

Quando eu busco por um produto e o adiciono ao carrinho
    Buscar e Selecionar Produto na Sugestão    HP ROAR PLUS WIRELESS SPEAKER
    Adicionar Produto ao Carrinho

Então o produto deve ser exibido corretamente no carrinho
    Verificar Produto no Carrinho    HP ROAR PLUS WIRELESS SPEAKER