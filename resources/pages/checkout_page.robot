*** Settings ***
Documentation     Page Object para o fluxo de Carrinho e Pagamento.
Resource          ../common_keywords.robot

*** Variables ***
# Variáveis do Carrinho
${SHOPPING_CART_LINK}   id:shoppingCartLink
${PRODUCT_NAME_IN_CART}   xpath=//td[@class='smollCell'][2]/a/h3
${CHECKOUT_BUTTON}      id:checkOutPopUp

# Variáveis do Pagamento
${NEXT_BUTTON}          id:next_btn
${SAFE_PAY_OPTION}      xpath=//div[contains(@class, 'imgRadioButton')][./input[@name='safepay']]
${SAFE_PAY_USERNAME}    name:safepay_username
${SAFE_PAY_PASSWORD}    name:safepay_password
${PAY_NOW_BUTTON}       id:pay_now_btn_SAFEPAY
${SUCCESS_MESSAGE}      xpath=//h2/span[contains(., 'Thank you for buying with Advantage')]

*** Keywords ***
Verificar Produto no Carrinho
    [Documentation]    Acessa o carrinho e verifica se o produto está listado.
    [Arguments]    ${nome_produto}
    Click Element    ${SHOPPING_CART_LINK}
    Wait Until Page Contains    SHOPPING CART    timeout=10s
    ${product_locator}=    Set Variable    xpath=//*[self::h3 or self::label][normalize-space()='${nome_produto}']
    Wait Until Page Contains Element    ${product_locator}    timeout=10s
    Log To Console    --- Produto "${nome_produto}" verificado no carrinho com sucesso ---

Prosseguir Para Tela de Pagamento
    [Documentation]    Navega do carrinho até a tela de pagamento de forma robusta.
    Click If Element Is Visible    ${CHECKOUT_BUTTON}
    Wait Until Page Contains Element    id:orderPayment    timeout=10s
    Click If Element Is Visible    ${NEXT_BUTTON}
    Wait Until Page Contains    SafePay username    timeout=15s

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
    Wait Until Element Is Visible    ${SUCCESS_MESSAGE}    timeout=20s
    Log To Console    --- Compra finalizada e validada com sucesso! ---