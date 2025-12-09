*** Settings ***
Library    SeleniumLibrary
Resource   ../config/dev.robot
Resource   login.resource
Resource   random_data.resource

*** Keywords ***
Acessar Pagina Centro de Custo
    Click Element    id:Cadastros

    Wait Until Element Is Visible    id:Centro de Custo    timeout=10s
    Click Element    id:Centro de Custo

    Wait Until Location Is    ${BASE_URL_UI}/costCenter    timeout=10s
    Location Should Be        ${BASE_URL_UI}/costCenter

    Wait Until Element Is Visible    xpath://h1[text()='Centro de Custo']    timeout=10s
    Element Text Should Be          xpath://h1[text()='Centro de Custo']    Centro de Custo

Cadastrar Novo Centro de Custo
    Wait Until Element Is Visible    xpath://button[text()='Novo Centro de Custo']    timeout=10s
    Click Button    xpath://button[text()='Novo Centro de Custo']

    Wait Until Element Is Visible    xpath://h2[text()='Novo Centro de Custo']    timeout=10s
    Element Should Be Visible    xpath://h2[text()='Novo Centro de Custo']

    ${costCenterName}    Gerar Departamento Da Lista
    Input Text    id:costCentername    ${costCenterName}

    Wait Until Element Is Visible    xpath=//select    timeout=10s
    Sleep    2s

    ${itens}=    Get List Items    xpath=//select
    ${itens_filtrados}=    Create List

    FOR    ${item}    IN    @{itens}
        Run Keyword If    '${item}' != ''    
        ...    Append To List    ${itens_filtrados}    ${item}
    END

    ${primeiro}=    Get From List    ${itens_filtrados}    1
    Select From List By Label    xpath=//select    ${primeiro}

    Wait Until Element Is Visible    xpath://button[text()='Salvar']    timeout=10s
    Click Button    xpath://button[text()='Salvar']
    Wait Until Page Contains    ${costCenterName}    timeout=10s

    Sleep   5s
