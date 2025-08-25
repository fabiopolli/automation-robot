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

# --- Variáveis de Busca e Produto ---
${SEARCH_ICON}          id:menuSearch
${SEARCH_INPUT}         id:autoComplete
${ADD_TO_CART_BUTTON}   name:save_to_cart

# --- Variáveis do Carrinho e Checkout ---
${SHOPPING_CART_LINK}   id:shoppingCartLink
${PRODUCT_NAME_IN_CART}   xpath=//td[@class='smollCell'][2]/a/h3
${CHECKOUT_BUTTON}      id:checkOutPopUp
${NEXT_BUTTON}          id:next_btn
${SAFE_PAY_OPTION}      xpath=//div[contains(@class, 'imgRadioButton')][./input[@name='safepay']]
${SAFE_PAY_USERNAME}    name:safepay_username
${SAFE_PAY_PASSWORD}    name:safepay_password
${PAY_NOW_BUTTON}       id:pay_now_btn_SAFEPAY
${SUCCESS_MESSAGE}      xpath=//span[text()='Thank you for your order!']
${LOADER_SPINNER}       css:div.loader

*** Keywords ***
# --- Keywords de Setup e Login ---
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
        Click If Element Is Visible    ${POPUP_CLOSE_BUTTON}
    END

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

# --- Keywords de Busca e Compra ---
Buscar e Selecionar Produto na Sugestão
    [Documentation]    Clica na lupa, digita o nome do produto e seleciona na lista.
    [Arguments]    ${nome_produto}
    Click If Element Is Visible    ${SEARCH_ICON}
    Input Text If Element Is Visible    ${SEARCH_INPUT}    ${nome_produto}
    Sleep    3s
    ${suggestion_locator}=    Set Variable    xpath=//div[@id="output"]//a[@class="product ng-scope"]//*[contains(text(),'${nome_produto}')]
    Click If Element Is Visible    ${suggestion_locator}
    Wait Until Element Contains    xpath=//*[@id="Description"]/h1    ${nome_produto}    timeout=10s

Adicionar Produto ao Carrinho
    [Documentation]    Na página do produto, clica no botão para adicionar ao carrinho.
    Click If Element Is Visible    ${ADD_TO_CART_BUTTON}

Verificar Produto no Carrinho
    [Documentation]    Acessa o carrinho e verifica se o produto está listado.
    [Arguments]    ${nome_produto}
    Click Element    ${SHOPPING_CART_LINK}
    Wait Until Page Contains    SHOPPING CART    timeout=10s
    ${product_locator}=    Set Variable    xpath=//*[self::h3 or self::label][normalize-space()='${nome_produto}']
    Wait Until Page Contains Element    ${product_locator}    timeout=10s
    Log To Console    --- Produto "${nome_produto}" verificado no carrinho com sucesso ---


# --- KEYWORDS DE PAGAMENTO COM SUAS SUGESTÕES APLICADAS ---
Tentar Prosseguir Para Pagamento
    [Documentation]    Tenta executar a navegação para o pagamento com retentativas.
    Wait Until Keyword Succeeds    3x    5s    Prosseguir Para Tela de Pagamento

Prosseguir Para Tela de Pagamento
    [Documentation]    Navega do carrinho até a tela de pagamento de forma robusta.
    Click If Element Is Visible    ${CHECKOUT_BUTTON}
    Wait Until Page Contains Element    id:orderPayment    timeout=10s
    Click If Element Is Visible    ${NEXT_BUTTON}
    Wait Until Page Contains         SafePay username    timeout=30s
    Scroll Element Into View         ${SAFE_PAY_OPTION}
    Sleep    0.5s
    Wait Until Element Is Visible    ${SAFE_PAY_OPTION}    timeout=10s

Preencher e Validar Credenciais SafePay
    [Documentation]    Preenche os dados do SafePay e valida o preenchimento.
    [Arguments]    ${username}    ${password}
    Click If Element Is Visible         ${SAFE_PAY_OPTION}
    Click Element                       ${SAFE_PAY_USERNAME}
    Input Text                          ${SAFE_PAY_USERNAME}       ${username}
    Textfield Value Should Be           ${SAFE_PAY_USERNAME}       ${username}
    Click Element                       ${SAFE_PAY_PASSWORD}
    Input Text                          ${SAFE_PAY_PASSWORD}       ${password}
    Textfield Value Should Be           ${SAFE_PAY_PASSWORD}       ${password}

Validar Compra Realizada com Sucesso
    [Documentation]    Verifica a mensagem de sucesso após o pagamento.
    # CORREÇÃO: Espera pela mensagem exata que aparece na tela de sucesso.
    ${success_locator}=    Set Variable    xpath=//h2/span[contains(., 'Thank you for buying with Advantage')]
    Wait Until Element Is Visible    ${success_locator}    timeout=20s
    Log To Console    --- Compra finalizada e validada com sucesso! ---

# --- Keywords Utilitárias ---
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
    [Documentation]    Aguarda um campo ser visível e então digita.
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    timeout=15s
    Wait Until Element Is Enabled    ${locator}    timeout=15s
    Input Text    ${locator}    ${text}
    Wait Loader

# --- Keyword Especial para o clique problemático ---
Click User Icon via Javascript
    [Documentation]    Usa JavaScript para clicar no ícone de usuário, evitando interceptação.
    Wait Until Element Is Visible    ${USER_ICON}    timeout=15s
    ${element}=    Get Webelement    ${USER_ICON}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}
    Wait Loader