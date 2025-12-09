*** Settings ***
Resource    ../../resources/company.resource
Library    SeleniumLibrary    screenshot_root_directory=None

 
Test Setup       Abrir Navegador
Test Teardown    Fechar Navegador
 
*** Test Cases ***
Cenario 01: Cadastrar nova empresa
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Cadastrar Nova Empresa  