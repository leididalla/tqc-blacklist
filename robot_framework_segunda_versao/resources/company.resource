*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    RequestsLibrary
Library    FakerLibrary    locale=pt_BR
Resource    ../resources/generate_random_data.resource
Resource    ../config/dev.robot

*** Keywords ***
Criar Sessao
    ${headers}=    Create Dictionary   accept=application/json    Content-Type=application/json
    Create Session   alias=develop   url=${BASE_URL}    headers=${headers}

Realizar login
    ${body}=    Create Dictionary    mail=${USER_EMAIL}    password=${USER_PASSWORD}
    Criar Sessao
    ${bodyResponse}    POST On Session    alias=develop    url=/login    json=${body}    verify=${True}
    Log     ${bodyResponse.json()}
    Log    ${bodyResponse.json()['token']}
    Status Should Be    200    ${bodyResponse}
    RETURN    ${bodyResponse.json()['token']}

Gerar Empresa
    ${corporateName}=        Gerar nome da empresa
    ${unique}=               Generate Random String    5    [LETTERS]
    ${corporateName}=        Catenate    SEPARATOR=    ${corporateName}_${unique}
    ${registerCompany}=      Gera cnpj da empresa
    ${mail}=                 Set Variable   ${corporateName.lower()}@qacoders.com
    ${firstName}=            Gerar primeiro nome nao composto
    ${lastName}=             Gerar ultimo nome nao composto
    ${responsibleContact}=   Set Variable    ${firstName} ${lastName}
    ${telephone}=            Generate Random String    11    [NUMBERS]
    ${serviceDescription}=   Sentence    6
    ${zipCode}=              Gerar cep sem caracteres especiais
    ${city}=                 City
    ${state}=                Gerar sigla do estado
    ${district}=             Street Name
    ${street}=               Gerar logradouro sem caracteres especiais
    ${number}=               Building Number
    ${complement}=           Generate Random String    5    [LETTERS]
    #${country}=              Gerar pais Sem Acentos

    Set Suite Variable       ${COMPANY_NAME}          ${corporateName}
    Set Suite Variable       ${REGISTER_COMPANY}      ${registerCompany}
    Set Suite Variable       ${MAIL}                  ${mail}
    Set Suite Variable       ${MATRIZ}                teste
    Set Suite Variable       ${RESPONSIBLE_CONTACT}   ${responsibleContact}
    Set Suite Variable       ${TELEPHONE}             ${telephone}
    Set Suite Variable       ${SERVICE_DESCRIPTION}   ${serviceDescription}
    Set Suite Variable       ${ZIPCODE}               ${zipCode}
    Set Suite Variable       ${CITY}                  ${city}
    Set Suite Variable       ${STATE}                 ${state}
    Set Suite Variable       ${DISTRICT}              ${district}
    Set Suite Variable       ${STREET}                ${street}
    Set Suite Variable       ${NUMBER}                ${number}
    Set Suite Variable       ${COMPLEMENT}            ${complement}
    Set Suite Variable       ${COUNTRY}               Brasil
   
Cadastrar nova empresa
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}
    
    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}
    
    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}
    
    ${response}    POST On Session    alias=develop    url=/company?token=${TOKEN}    json=${body}    verify=${True}
    Status Should Be    201    ${response}
    Log     ${response.json()}
    Set Suite Variable    ${COMPANY_ID}    ${response.json()['newCompany']['_id']}
    
Atualizar dados da empresa cadastrado por id
    Gerar Empresa
    ${TOKEN}    Realizar login
        ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}
    
    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}
    
    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}
    
    ${response}    PUT On Session    alias=develop    url=/company/${COMPANY_ID}?token=${TOKEN}    json=${body}    verify=${True}
    Status Should Be    200    ${response}
    ${resp_json}=    Set Variable    ${response.json()}
    Log     ${response.json()}

Deletar empresa cadastrada por id
    ${TOKEN}    Realizar login
    DELETE On Session    alias=develop    url=/company/${COMPANY_ID}?token=${token}    verify=${True}
    
Cadastrar empresa com CNPJ invalido
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}abc
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}
    
    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}
    
    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}
    
    ${response}    POST On Session    alias=develop    url=/company?token=${TOKEN}    json=${body}    expected_status=400    verify=${True}
    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'CNPJ' da empresa deve conter 14 caracteres numéricos.

Cadastrar empresa com CNPJ duplicado
    # 1) Criar a empresa pela primeira vez
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    # PRIMEIRO POST: cadastrar empresa válida
    ${response}=    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=201
    ...    verify=${True}

    # 2) Guardar o mesmo CNPJ para reusar
    ${CNPJ_DUPLICADO}=    Set Variable    ${REGISTER_COMPANY}

    # 3) Criar body novamente, mas SEM chamar Gerar Empresa
    ${body2}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${CNPJ_DUPLICADO}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    Set To Dictionary    ${body2}    address=${final_ddress_list}

    # SEGUNDO POST: deve falhar com duplicidade
    ${response2}=    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body2}
    ...    expected_status=400
    ...    verify=${True}

    Log    ${response2.json()}
    Should Be Equal As Strings    ${response2.json()['alert'][0]}    O CNPJ informado já está cadastrado.

Cadastrar empresa com CEP invalido com caracteres especiais
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=@@@###       # <-- APENAS ESTA LINHA MUDA
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    CEP

Cadastrar empresa com CEP invalido com menos digitos
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=12345       # <-- APENAS ESTA LINHA MUDA
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    CEP

Cadastrar empresa com CEP invalido com mais digitos
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=123456789      # <-- APENAS ESTA LINHA MUDA
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    CEP

Cadastrar empresa com email invalido
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=email_invalido@@    # <-- APENAS ESTA LINHA MUDA
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'Email' informado é inválido.

Cadastrar empresa com telefone invalido
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=ABC123@@@      # <-- APENAS ESTA LINHA MUDA
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'Telefone' deve conter somente números.

Cadastrar empresa omitindo nome
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=         # <-- APENAS ESTA LINHA MUDA (nome vazio)
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log    ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'Nome da empresa' é obrigatório.

Cadastrar empresa omitindo nome e sobrenome
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=       # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log    ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'Contato do Responsável' é obrigatório.

Cadastrar empresa omitindo cidade
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=              # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'cidade' é obrigatório.

Cadastrar empresa omitindo descricao do servidor
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=         # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'Descrição' é obrigatório.

Cadastrar empresa omitindo bairro
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=                # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'bairro' é obrigatório.

Cadastrar empresa omitindo cep
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=                # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'CEP' é obrigatório.

Cadastrar empresa omitindo cnpj
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=           # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'CNPJ' da empresa é obrigatório.

Cadastrar empresa omitindo email
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=                 # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'Email' é obrigatório.

Cadastrar empresa omitindo estado
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=                # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'estado' é obrigatório.

Cadastrar empresa omitindo logradouro
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=                # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'logradouro' é obrigatório.

Cadastrar empresa omitindo nome da empresa
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=              # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'Nome da empresa' é obrigatório.

Cadastrar empresa omitindo numero
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=                 # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'número' é obrigatório.

Cadastrar empresa omitindo pais
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=${TELEPHONE}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=                 # <-- APENAS ESTA LINHA MUDA (campo vazio)

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo País é obrigatório.

Cadastrar empresa omitindo telefone
    Gerar Empresa
    ${TOKEN}    Realizar login

    ${body}=    Create Dictionary
    ...    corporateName=${COMPANY_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL}
    ...    matriz=${MATRIZ}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    telephone=               # <-- APENAS ESTA LINHA MUDA (campo vazio)
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    address=${EMPTY}

    ${address_dict}=    Create Dictionary
    ...    zipCode=${ZIPCODE}
    ...    city=${CITY}
    ...    state=${STATE}
    ...    district=${DISTRICT}
    ...    street=${STREET}
    ...    number=${NUMBER}
    ...    complement=${COMPLEMENT}
    ...    country=${COUNTRY}

    ${final_ddress_list}=    Create List    ${address_dict}
    Set To Dictionary    ${body}    address=${final_ddress_list}

    ${response}    POST On Session
    ...    alias=develop
    ...    url=/company?token=${TOKEN}
    ...    json=${body}
    ...    expected_status=400
    ...    verify=${True}

    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Contain    ${response.json()['error'][0]}    O campo 'Telefone' é obrigatório.

#Cadastrar empresa sem permissao
    #Gerar Empresa
    #${TOKEN_SEM_PERMISSAO}    Realizar login sem permissao

    #${body}=    Create Dictionary
    #...    corporateName=${COMPANY_NAME}
    #...    registerCompany=${REGISTER_COMPANY}
    #...    mail=${MAIL}
    #...    matriz=${MATRIZ}
    #...    responsibleContact=${RESPONSIBLE_CONTACT}
    #...    telephone=${TELEPHONE}
    #...    serviceDescription=${SERVICE_DESCRIPTION}
    #...    address=${EMPTY}

    #${address_dict}=    Create Dictionary
    #...    zipCode=${ZIPCODE}
    #...    city=${CITY}
    #...    state=${STATE}
    #...    district=${DISTRICT}
    #...    street=${STREET}
    #...    number=${NUMBER}
    #...    complement=${COMPLEMENT}
    #...    country=${COUNTRY}

    #${final_ddress_list}=    Create List    ${address_dict}
    #Set To Dictionary    ${body}    address=${final_ddress_list}

    #${response}    POST On Session
    #...    alias=develop
    #...    url=/company?token=${TOKEN_SEM_PERMISSAO}
    #...    json=${body}
    #...    expected_status=403
    #...    verify=${True}

    #Status Should Be    403    ${response}
    #Log     ${response.json()}
    #Should Contain    ${response.json()['error']}    Usuário não possui permissão para cadastrar empresa.
