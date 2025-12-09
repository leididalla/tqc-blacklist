*** Settings ***
Resource    ../../resources/common.resource
Resource    ../../resources/random_data.resource
Resource    ../../resources/department.resource

Suite Setup       Abrir Navegador
Suite Teardown    Fechar Navegador

*** Test Cases ***
Cenario 01: Cadastrar Departamento
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Departamentos
    Cadastrar Novo Departamento