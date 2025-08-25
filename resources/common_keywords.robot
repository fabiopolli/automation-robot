*** Settings ***
Documentation     Keywords comuns e utilitárias para todo o projeto.

Library           SeleniumLibrary
Library           OperatingSystem

*** Variables ***
${LOADER_SPINNER}       css:div.loader
${POPUP_CLOSE_BUTTON}   css:.PopUp .closeBtn

*** Keywords ***
Carregar Variaveis de Ambiente Web
    [Documentation]    Carrega as variáveis do arquivo .env para a sessão atual.
    Evaluate          __import__('dotenv').load_dotenv()    dotenv

Abrir Navegador e Acessar a Página Principal
    [Documentation]    Abre o navegador, acessa a URL e lida com o pop-up inicial.
    Carregar Variaveis de Ambiente Web
    ${site_url}=      Get Environment Variable    SITE_URL
    ${browser}=       Get Environment Variable    BROWSER
    Open Browser      url=${site_url}    browser=${browser}
    Maximize Browser Window
    Set Selenium Implicit Wait    10s
    Log To Console    \n--- Navegador aberto no site: ${site_url} ---
    Lidar com Pop-up Inicial

Lidar com Pop-up Inicial
    [Documentation]    Verifica se o pop-up promocional está visível e o fecha.
    ${is_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${POPUP_CLOSE_BUTTON}    timeout=5s
    IF    ${is_visible}
        Click Element    ${POPUP_CLOSE_BUTTON}
    END

Wait Loader
    [Documentation]    Aguarda o spinner de carregamento GENÉRICO desaparecer.
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${LOADER_SPINNER}    timeout=3s
    IF    ${status}
        Wait Until Element Is Not Visible    ${LOADER_SPINNER}    timeout=20s
    END
    Sleep    0.2s

Click If Element Is Visible
    [Documentation]    Aguarda um elemento ser clicável e então clica de forma padrão.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=15s
    Wait Until Element Is Enabled    ${locator}    timeout=15s
    Click Element    ${locator}
    Wait Loader

Input Text If Element Is Visible
    [Documentation]    Clica, aguarda um campo ser visível e então digita.
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    timeout=15s
    Wait Until Element Is Enabled    ${locator}    timeout=15s
    Click Element    ${locator}
    Input Text    ${locator}    ${text}
    Wait Loader

Click User Icon via Javascript
    [Documentation]    Usa JavaScript para clicar no ícone de usuário, evitando interceptação.
    Wait Until Element Is Visible    xpath://a[@id='hrefUserIcon']    timeout=15s
    ${element}=    Get Webelement    xpath://a[@id='hrefUserIcon']
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}
    Wait Loader