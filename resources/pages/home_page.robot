*** Settings ***
Documentation     Page Object para a Home Page (Login e Busca).
Resource          ../common_keywords.robot

*** Variables ***
# Variáveis de Login
${USER_ICON}            xpath://a[@id='hrefUserIcon']
${LOGIN_USERNAME_INPUT}   name:username
${LOGIN_PASSWORD_INPUT}   name:password
${SIGN_IN_BUTTON}       id:sign_in_btn
${LOGIN_ERROR_MESSAGE}  id:signInResultMessage

# Variáveis de Busca
${SEARCH_ICON}          id:menuSearch
${SEARCH_INPUT}         id:autoComplete

*** Keywords ***
Fazer Login Pela Interface
    [Documentation]    Executa os passos para fazer login no site.
    [Arguments]    ${username}    ${password}
    Click User Icon via Javascript
    Input Text If Element Is Visible    ${LOGIN_USERNAME_INPUT}    ${username}
    Input Text If Element Is Visible    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click If Element Is Visible    ${SIGN_IN_BUTTON}

Verificar Login Bem Sucedido
    [Documentation]    Verifica se o nome do usuário aparece na tela após o login.
    [Arguments]    ${username}
    Wait Until Page Contains    ${username}    timeout=15s
    Log To Console    --- Login verificado com sucesso para o usuário: ${username} ---

Verificar Mensagem de Login Invalido
    [Documentation]    Verifica se a mensagem de erro para login inválido está visível.
    Wait Until Element Is Visible    ${LOGIN_ERROR_MESSAGE}    timeout=10s
    Element Should Contain           ${LOGIN_ERROR_MESSAGE}    Incorrect user name or password.
    Log To Console                   --- Mensagem de erro de login validada com sucesso ---

Buscar e Selecionar Produto na Sugestão
    [Documentation]    Clica na lupa, digita o nome do produto e seleciona na lista.
    [Arguments]    ${nome_produto}
    Click If Element Is Visible    ${SEARCH_ICON}
    Input Text If Element Is Visible    ${SEARCH_INPUT}    ${nome_produto}
    Sleep    3s
    ${suggestion_locator}=    Set Variable    xpath=//div[@id="output"]//a[@class="product ng-scope"]//*[contains(text(),'${nome_produto}')]
    Click If Element Is Visible    ${suggestion_locator}
    Wait Until Element Contains    xpath=//*[@id="Description"]/h1    ${nome_produto}    timeout=10s