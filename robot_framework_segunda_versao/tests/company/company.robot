*** Settings ***
Documentation     Keywords utilizadas na rota /company
Resource    ../../resources/company.resource

*** Test Cases ***
# --- Testes de sucesso ---

Cadastrar empresa com sucesso
    Cadastrar nova empresa

# --- Testes de exceção --- VALIDAÇÕES DE CAMPO

Cadastrar empresa com CNPJ inválido
    Cadastrar empresa com CNPJ invalido

Cadastrar empresa com CNPJ duplicado
    Cadastrar empresa com CNPJ duplicado

Cadastrar empresa com CEP inválido (caracteres especiais)
    Cadastrar empresa com CEP invalido com caracteres especiais

Cadastrar empresa com CEP inválido (menos dígitos)
    Cadastrar empresa com CEP invalido com menos digitos

Cadastrar empresa com CEP inválido (mais dígitos)
    Cadastrar empresa com CEP invalido com mais digitos

Cadastrar empresa com e-mail inválido
    Cadastrar empresa com email invalido

Cadastrar empresa com telefone inválido
    Cadastrar empresa com telefone invalido

# --- Testes de campos omitidos ---

Cadastrar empresa omitindo 'Nome'
    Cadastrar empresa omitindo nome

Cadastrar empresa omitindo 'Nome e Sobrenome'
    Cadastrar empresa omitindo nome e sobrenome

Cadastrar empresa omitindo 'cidade'
    Cadastrar empresa omitindo cidade

Cadastrar empresa omitindo 'Descrição do Servidor'
    Cadastrar empresa omitindo descricao do servidor

Cadastrar empresa omitindo 'bairro'
    Cadastrar empresa omitindo bairro

Cadastrar empresa omitindo 'CEP'
    Cadastrar empresa omitindo cep

Cadastrar empresa omitindo 'CNPJ'
    Cadastrar empresa omitindo cnpj

Cadastrar empresa omitindo 'E-mail'
    Cadastrar empresa omitindo email

Cadastrar empresa omitindo 'estado'
    Cadastrar empresa omitindo estado

Cadastrar empresa omitindo 'logradouro'
    Cadastrar empresa omitindo logradouro

Cadastrar empresa omitindo 'Nome da Empresa'
    Cadastrar empresa omitindo nome da empresa

Cadastrar empresa omitindo 'numero'
    Cadastrar empresa omitindo numero

Cadastrar empresa omitindo 'Pais'
    Cadastrar empresa omitindo pais

Cadastrar empresa omitindo 'telefone'
    Cadastrar empresa omitindo telefone

# --- Testes de permissão ---

#Cadastrar empresa sem permissão (não admin)
    #Cadastrar empresa sem permissao
    #[Tags]    skip
    #Comment    API não possui controle de permissão. Todos logins são admin.
