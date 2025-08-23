*** Settings ***
Documentation     Keywords reutilizáveis para interagir com a interface web.

Library           SeleniumLibrary
Library           OperatingSystem

*** Variables ***
# --- Variáveis de Login e Pop-up ---
${USER_ICON}            xpath://a[@id='hrefUserIcon']
${LOGIN_USERNAME_INPUT}   name:username
${LOGIN_PASSWORD_INPUT}   name:password
${SIGN_IN_BUTTON}       id:sign_in_btn
${POPUP_CLOSE_BUTTON}   css:.PopUp .closeBtn

# --- Variáveis de Busca ---
${SEARCH_ICON}          id:menuSearch
${SEARCH_INPUT}         id:autoComplete

# --- Variáveis de Produto e Carrinho ---
${ADD_TO_CART_BUTTON}   name:save_to_cart
${SHOPPING_CART_LINK}   id:shoppingCartLink

*** Keywords ***
# --- Keywords de Setup ---
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
        Log To Console    --- Pop-up promocional fechado ---
    END

# --- Keywords de Login (Já funcionais) ---
Fazer Login Pela Interface
    [Documentation]    Executa os passos para fazer login no site.
    [Arguments]    ${username}    ${password}
    Click If Element Is Visible    ${USER_ICON}
    Input Text If Element Is Visible    ${LOGIN_USERNAME_INPUT}    ${username}
    Input Text If Element Is Visible    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click If Element Is Visible    ${SIGN_IN_BUTTON}

Verificar Login Bem Sucedido
    [Documentation]    Verifica se o nome do usuário aparece na tela após o login.
    [Arguments]    ${username}
    Wait Until Page Contains    ${username}    timeout=15s
    Log To Console    --- Login verificado com sucesso para o usuário: ${username} ---

# --- Keywords de Busca e Compra ---
Buscar e Selecionar Produto na Sugestão
    [Documentation]    Clica na lupa, digita o nome do produto e seleciona na lista.
    [Arguments]    ${nome_produto}
    Click If Element Is Visible    ${SEARCH_ICON}
    Input Text If Element Is Visible    ${SEARCH_INPUT}    ${nome_produto}
    Sleep    10s
    ${suggestion_locator}=    Set Variable    xpath=//div[@id="output"]//a[@class="product ng-scope"]//*[contains(text(),'${nome_produto}')]
    Click If Element Is Visible    ${suggestion_locator}
    Wait Until Element Contains    xpath=//*[@id="Description"]/h1    ${nome_produto}    timeout=10s

Adicionar Produto ao Carrinho
    [Documentation]    Na página do produto, clica no botão para adicionar ao carrinho.
    Click If Element Is Visible    ${ADD_TO_CART_BUTTON}

Verificar Produto no Carrinho
    [Documentation]    Acessa o carrinho e verifica se o produto está listado.
    Sleep    10s
    [Arguments]    ${nome_produto}
    Click Element    ${SHOPPING_CART_LINK}
    Wait Until Page Contains    SHOPPING CART    timeout=10s
    
    # --- LÓGICA DE VERIFICAÇÃO CORRIGIDA E MAIS ROBUSTA ---
    ${product_locator}=    Set Variable    xpath=//*[self::h3 or self::label][normalize-space()='${nome_produto}']
    Wait Until Page Contains Element    ${product_locator}    timeout=10s
    Log To Console    --- Produto "${nome_produto}" verificado no carrinho com sucesso ---

# --- Keywords Utilitárias (Sua Lógica Superior e Comprovada) ---
Wait loader
    [Documentation]    Espera o loader específico do login ficar desabilitado e invisível.
    Wait Until Element Is Enabled    xpath=//login-modal//div[@class="loader" and @style="display: none; opacity: 0;"]    timeout=15s
    Sleep    0.5s

Click If Element Is Visible
    [Documentation]    Aguarda um elemento ser clicável e então clica, esperando loaders.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=15s
    Wait Until Element Is Enabled    ${locator}    timeout=15s
    Run Keyword And Ignore Error    Set Focus To Element    ${locator}
    Wait loader
    Click Element    ${locator}

Input Text If Element Is Visible
    [Documentation]    Aguarda um campo ser visível e então digita, esperando loaders.
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    timeout=1s
    Wait Until Element Is Enabled    ${locator}    timeout=15s
    Run Keyword And Ignore Error    Set Focus To Element    ${locator}
    Wait loader
    Input Text    ${locator}    ${text}