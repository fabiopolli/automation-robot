*** Settings ***
Documentation     Keywords reutilizáveis para interagir com a interface web.

Library           SeleniumLibrary
Library           OperatingSystem

*** Variables ***
${USER_ICON}            xpath://a[@id='hrefUserIcon']
${LOGIN_USERNAME_INPUT}   name:username
${LOGIN_PASSWORD_INPUT}   name:password
${SIGN_IN_BUTTON}       id:sign_in_btn
${LOADER_SPINNER}       css:div.loader

*** Keywords ***
Carregar Variaveis de Ambiente Web
    [Documentation]    Carrega as variáveis do arquivo .env para a sessão atual.
    Evaluate          __import__('dotenv').load_dotenv()    dotenv

Abrir Navegador e Acessar a Página Principal
    [Documentation]    Abre o navegador e acessa a URL principal definida no .env.
    Carregar Variaveis de Ambiente Web
    ${site_url}=      Get Environment Variable    SITE_URL
    ${browser}=       Get Environment Variable    BROWSER
    Open Browser      url=${site_url}    browser=${browser}
    Maximize Browser Window
    Set Selenium Implicit Wait    10s
    Log To Console    \n--- Navegador aberto no site: ${site_url} ---

Fazer Login Pela Interface
    [Documentation]    Executa os passos para fazer login no site.
    [Arguments]    ${username}    ${password}
    Click Element If Visible    ${USER_ICON}
    Input Text If Visible    ${LOGIN_USERNAME_INPUT}    ${username}
    Input Text If Visible    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click Element If Visible    ${SIGN_IN_BUTTON}

Verificar Login Bem Sucedido
    [Documentation]    Verifica se o nome do usuário aparece na tela após o login.
    [Arguments]    ${username}
    Wait Until Page Contains    ${username}    timeout=15s
    Log To Console    --- Login verificado com sucesso para o usuário: ${username} ---

# --- KEYWORDS UTILITÁRIAS COM ESPERA OTIMIZADA ---
Wait Loader
    [Documentation]    Aguarda o spinner de carregamento desaparecer de forma eficiente.
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${LOADER_SPINNER}    timeout=2s
    IF    ${status}
        Wait Until Element Is Not Visible    ${LOADER_SPINNER}    timeout=15s
    END

Click Element If Visible
    [Documentation]    Aguarda um elemento ser clicável e então clica, esperando loaders.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Wait Until Element Is Enabled    ${locator}    timeout=10s
    Click Element    ${locator}
    Wait Loader

Input Text If Visible
    [Documentation]    Aguarda um campo ser visível e então digita, esperando loaders.
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Wait Until Element Is Enabled    ${locator}    timeout=10s
    Input Text    ${locator}    ${text}
    Wait Loader