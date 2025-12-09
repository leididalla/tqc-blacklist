*** Settings ***
Resource    ../resources/login.resource
 
Suite Setup       Abrir Navegador
Suite Teardown    Fechar Navegador
 
*** Test Cases ***
Cenario 01: Realizar Login com Sucesso
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel