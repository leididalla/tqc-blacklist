*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    RequestsLibrary
Resource    ../config/dev.robot

*** Keywords ***
Criar Sessao
    ${headers}=    Create Dictionary   accept=application/json    Content-Type=application/json
    Create Session   alias=develop   url=${BASE_URL}    headers=${headers}

Realizar login
    ${body}=    Create Dictionary    mail=${USER_EMAIL}   password=${USER_PASSWORD}

    Criar Sessao
    ${bodyResponse}    POST On Session    
    ...    alias=${SESSION_ALIAS}     
    ...    url=/login    
    ...    json=${body}    
    ...    verify=${True}

    Log     ${bodyResponse.json()}
    Log    ${bodyResponse.json()['token']}
    Status Should Be    200    ${bodyResponse}

    RETURN    ${bodyResponse.json()['token']}

Realizar login sem permissao
    ${body}=    Create Dictionary    mail=${USER_EMAIL_NAO_ADMIN}    password=${USER_PASSWORD_NAO_ADMIN}

    Criar Sessao
    ${bodyResponse}=    POST On Session    
    ...    alias=develop    
    ...    url=/login    
    ...    json=${body}    
    ...    verify=${True}

    Log    ${response.json()}

    # Aqui você ajusta dependendo da resposta real da API:
    Status Should Be    401    ${response}
    Should Contain    ${response.json()['message']}    permissao

    RETURN    ${response.json()}
