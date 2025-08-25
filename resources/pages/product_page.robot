*** Settings ***
Documentation     Page Object para a Página de Detalhes do Produto.
Resource          ../common_keywords.robot

*** Variables ***
${ADD_TO_CART_BUTTON}   name:save_to_cart

*** Keywords ***
Adicionar Produto ao Carrinho
    [Documentation]    Na página do produto, clica no botão para adicionar ao carrinho.
    Click If Element Is Visible    ${ADD_TO_CART_BUTTON}