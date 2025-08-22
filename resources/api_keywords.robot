*** Settings ***
Documentation     Keywords para interagir com a API do Advantage Shopping.

Library           RequestsLibrary
Library           String
Library           Collections

*** Variables ***
${API_BASE_URL}    https://www.advantageonlineshopping.com

*** Keywords ***
Criar Novo Usuário Via API
    [Documentation]    Cria um usuário com dados aleatórios e retorna suas credenciais.
    
    # 1. Geração de Dados Aleatórios
    ${random_numbers}=    Generate Random String    6    0123456789
    ${username}=          Set Variable    username${random_numbers}
    ${password}=          Set Variable    Password123
    ${email}=             Set Variable    ${username}@test.com

    # 2. Montagem do Corpo da Requisição (Payload) - Versão final e correta
    &{body}=    Create Dictionary
    ...    accountType=USER
    ...    address=Rua dos Testes, ${random_numbers}
    ...    allowOffersPromotion=${True}
    ...    aobUser=${True}    # <-- CAMPO CRÍTICO ADICIONADO
    ...    cityName=Sao Paulo
    ...    country=BRAZIL_BR
    ...    email=${email}
    ...    firstName=TestUser
    ...    lastName=Auto${random_numbers}
    ...    loginName=${username}
    ...    password=${password}
    ...    phoneNumber=11999${random_numbers}
    ...    stateProvince=SP
    ...    zipcode=11690156

    # 3. Montagem dos Cabeçalhos (Headers)
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Origin=https://www.advantageonlineshopping.com
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36

    # 4. Envio da Requisição POST
    Create Session    api_session    ${API_BASE_URL}    verify=${False}
    ${response}=    POST On Session
    ...    api_session
    ...    /accountservice/accountrest/api/v1/register
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    # 5. Log da resposta para depuração
    Log To Console    \n--- DEBUG: Resposta Completa do Servidor ---
    Log To Console    Status Code: ${response.status_code}
    Log To Console    Response Body: ${response.text}
    Log To Console    ------------------------------------------\n
    
    # 6. Validação do status code
    Should Be Equal As Strings    ${response.status_code}    200    msg=O status code esperado era 200, mas o servidor retornou ${response.status_code}.

    Log To Console    --- Usuário criado via API: ${username} ---

    # 7. Retorno dos Dados do Usuário
    &{user_data}=    Create Dictionary
    ...    username=${username}
    ...    password=${password}
    ...    email=${email}
    RETURN    ${user_data}