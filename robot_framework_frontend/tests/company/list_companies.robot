*** Settings ***
Resource    ../../resources/list_companies.resource

Test Setup       Abrir Navegador
Test Teardown    Fechar Navegador


*** Test Cases ***
Cenario 01: Listar empresas com sucesso
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Verificar Listagem de Empresas Carregada

Cenario 02: Listar empresas de forma rapida e eficiente
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Verificar Carregamento Rapido da Listagem

Cenario 03: Paginacao funcionando com sucesso
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Verificar Listagem de Empresas Carregada
    Verificar Paginacao Funcionando

Cenario 04: Exibir informacoes basicas da empresa
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Verificar Listagem de Empresas Carregada
    Exibir Informacoes Basicas

Cenario 05: Buscar empresa com sucesso
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Verificar Listagem de Empresas Carregada
    Buscar Empresa Com Sucesso    texto=Teste

Cenario 06: Responsividade em Desktop
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Verificar Listagem de Empresas Carregada
    Responsividade da Listagem em Desktop

Cenario 07: Responsividade em Tablet
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Verificar Listagem de Empresas Carregada
    Responsividade da Listagem em Tablet

Cenario 08: Responsividade em Smartphone
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Empresas
    Verificar Listagem de Empresas Carregada
    Responsividade da Listagem em Smartphone