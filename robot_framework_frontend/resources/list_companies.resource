*** Settings ***
Library     SeleniumLibrary
Resource    random_data.resource
Resource    login.resource


*** Keywords ***

Acessar Pagina Empresas
    Click Element    id:Cadastros
    Wait Until Element Is Visible    id:Empresas    timeout=10s
    Click Element    id:Empresas
    Wait Until Element Is Visible    xpath://h1[text()='Empresas']    timeout=10s


Verificar Listagem de Empresas Carregada
    Wait Until Element Is Visible    xpath://th[normalize-space()='Nome']    timeout=10s


Verificar Carregamento Rapido da Listagem
    Wait Until Element Is Visible    xpath://th[normalize-space()='Nome']    timeout=5s


Verificar Paginacao Funcionando
    Wait Until Element Is Visible    xpath://*[name()='path' and contains(@d,'M7 5.70703')]    timeout=10s
    Click Element                    xpath://*[name()='path' and contains(@d,'M7 5.70703')]/ancestor::button
    
    Wait Until Element Is Visible    xpath://*[name()='path' and contains(@d,'M13.7751 1')]    timeout=10s
    Click Element                    xpath://*[name()='path' and contains(@d,'M13.7751 1')]/ancestor::button
    

Exibir Informacoes Basicas
    # Cabeçalhos previstos na PBI
    Wait Until Element Is Visible    xpath://th[normalize-space()='Nome']             timeout=10s
    Wait Until Element Is Visible    xpath://th[normalize-space()='E-mail']           timeout=10s
    Wait Until Element Is Visible    xpath://th[normalize-space()='Contato']          timeout=10s
    Wait Until Element Is Visible    xpath://th[normalize-space()='CNPJ']             timeout=10s
    # Wait Until Element Is Visible    xpath://th[normalize-space()='Responsável']      timeout=10s
    # Wait Until Element Is Visible    xpath://th[normalize-space()='Cidade']           timeout=10s
    # Wait Until Element Is Visible    xpath://th[normalize-space()='Estado']           timeout=10s
    # Wait Until Element Is Visible    xpath://th[normalize-space()='País']             timeout=10s
    Wait Until Element Is Visible    xpath://th[normalize-space()='Ações']            timeout=10s  #Editar

    # Primeira linha prevista pela PBI
    Element Should Be Visible        xpath://tbody/tr[1]/td[1]    # Nome
    Element Should Be Visible        xpath://tbody/tr[1]/td[2]    # E-mail
    Element Should Be Visible        xpath://tbody/tr[1]/td[3]    # Contato
    Element Should Be Visible        xpath://tbody/tr[1]/td[4]    # CNPJ
    # Element Should Be Visible        xpath://tbody/tr[1]/td[6]    # Responsável
    # Element Should Be Visible        xpath://tbody/tr[1]/td[7]    # Cidade
    # Element Should Be Visible        xpath://tbody/tr[1]/td[8]    # Estado
    # Element Should Be Visible        xpath://tbody/tr[1]/td[9]    # País
    Element Should Be Visible        xpath://tbody/tr[1]/td[5]    # Ações #(Editar)


Buscar Empresa Com Sucesso
    [Arguments]    ${texto}
    
    Wait Until Element Is Visible    xpath://input[@placeholder='Buscar por nome, CNPJ ou razão social...']    timeout=10s
    Input Text    xpath://input[@placeholder='Buscar por nome, CNPJ ou razão social...']    ${texto}
    Press Keys    xpath://input[@placeholder='Buscar por nome, CNPJ ou razão social...']    ENTER


Responsividade da Listagem em Desktop
    Set Window Size    1366    768
    Wait Until Element Is Visible    xpath://h1[text()='Empresas']    timeout=10s


Responsividade da Listagem em Tablet
    Set Window Size    768    1024
    Wait Until Element Is Visible    xpath://h1[text()='Empresas']    timeout=10s
    Sleep    time_=10s


Responsividade da Listagem em Smartphone
    Set Window Size    375    667
    Wait Until Element Is Visible    xpath://h1[text()='Empresas']    timeout=10s
    Sleep    time_=10s