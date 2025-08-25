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

[TC-04] Realizar Compra Completa com Sucesso
    [Tags]    web    pagamento    critico
    [Documentation]    Valida o fluxo completo de compra, do login ao pagamento.
    
    Dado que estou logado no sistema
    Quando eu busco por um produto e o adiciono ao carrinho
    E finalizo a compra com SafePay
    Então devo ver a confirmação de compra

[TC-05] Tentar Fazer Login com Senha Incorreta
    [Tags]    web    negativo    login
    [Documentation]    Valida se o sistema exibe uma mensagem de erro ao usar uma senha incorreta.

    Dado que acesso a página principal do site
    Quando insiro um usuário válido com uma senha incorreta
    Então uma mensagem de erro de login deve ser exibida


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
    Fazer Login Pela Interface    ${USER_CREDENTIALS}[username]    ${USER_CREDENTIALS}[password]

Então o login deve ser realizado com sucesso
    Verificar Login Bem Sucedido    ${USER_CREDENTIALS}[username]

Dado que estou logado no sistema
    Abrir Navegador e Acessar a Página Principal
    Fazer Login Pela Interface    ${USER_CREDENTIALS.username}    ${USER_CREDENTIALS.password}
    Verificar Login Bem Sucedido    ${USER_CREDENTIALS.username}

Quando eu busco por um produto e o adiciono ao carrinho
    Buscar e Selecionar Produto na Sugestão    HP ROAR PLUS WIRELESS SPEAKER
    Adicionar Produto ao Carrinho
    Verificar Produto no Carrinho                HP ROAR PLUS WIRELESS SPEAKER

E finalizo a compra com SafePay
    Tentar Prosseguir Para Pagamento
    Preencher e Validar Credenciais SafePay    ${USER_CREDENTIALS.username}    ${USER_CREDENTIALS.password}
    Click If Element Is Visible               ${PAY_NOW_BUTTON}

Então devo ver a confirmação de compra
    Validar Compra Realizada com Sucesso

Quando insiro um usuário válido com uma senha incorreta
    Fazer Login Pela Interface    ${USER_CREDENTIALS.username}    senha_incorreta_123

Então uma mensagem de erro de login deve ser exibida
    Verificar Mensagem de Login Invalido