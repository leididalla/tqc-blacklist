*** Settings ***
Library     SeleniumLibrary
Resource    common.resource

*** Variables ***
${BASE_URL_UI}          https://blacklist.qacoders.dev.br
${FRONTEND_EMAIL}       sysadmin@qacoders.com
${FRONTEND_PASSWORD}    1234@Test
 
*** Keywords ***
# Abrir Navegador
#     Open Browser    ${BASE_URL_UI}    Chrome
#     Maximize Browser Window
 
# Fechar Navegador
#     Close Browser

Realizar Login
    Wait Until Element Is Visible    id:email    timeout=10s
    Input Text    id:email    ${FRONTEND_EMAIL}
 
    Wait Until Element Is Visible    id:password    timeout=10s
    Input Text    id:password    ${FRONTEND_PASSWORD}
 
    Wait Until Element Is Visible    id:login    timeout=10s
    Click Button    id:login
    
Verificar Redirecionamento Para Home
    Wait Until Location Is    ${BASE_URL_UI}/home    timeout=10s
    Location Should Be    ${BASE_URL_UI}/home
 
Verificar Elemento Cadastros Visivel
    Wait Until Element Is Visible    id:Cadastros    timeout=10s
    Element Text Should Be    id:Cadastros    Cadastros