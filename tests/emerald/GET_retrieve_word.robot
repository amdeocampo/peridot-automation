*** Variables ***
${headerRefNum}  x-emerald-ref-num
${refNum}  468656
${incorrectRefNum}  123456789
${headerAuth}  authorization
${authorization}  Basic b0pCNGRaUzdDMHI3cU5LOWgzM1Ixdzo=
${incompleteAuth}  Basic Og==
${apiServer}  https://emerald.staging.api.oleloapp.com

*** Settings ***
Test Setup  create http context  emerald.staging.api.oleloapp.com  https
Library  Collections
Library  RequestsLibrary
Library  HttpLibrary.HTTP
Library  ../Resources/utility_backend.py

*** Test Cases ***
#Without authorization and reference number
#    create session  emerald-api-staging  ${apiServer}
#    ${resp}=  get request  emerald-api-staging  /api/words/retrieve
#    should be equal as strings  ${resp.status_code}  401
#    ${errorMessage}=  get json error attribute value  ${apiServer}  /api/words/retrieve  message
#    should be equal as strings  ${errorMessage}  No description available for this error.
#    ${errorMessage}=  get json error attribute value  ${apiServer}  /api/words/retrieve  id
#    should be equal as strings  ${errorMessage}  unauthorized
#
#Without reference number
#    create session  emerald-api-staging  ${apiServer}
#    ${headers}=  create dictionary  ${headerAuth}=${authorization}
#    ${resp}=  get request  emerald-api-staging  /api/words/retrieve  headers=${headers}
#    should be equal as strings  ${resp.status_code}  401
#    ${errorMessage}=  get json incomplete error attribute value  ${apiServer}  /api/words/retrieve  message
#    ...                                                          ${headerAuth}  ${authorization}
#    should be equal as strings  ${errorMessage}  You provided an invalid reference number.
#    ${errorMessage}=  get json incomplete error attribute value  ${apiServer}  /api/words/retrieve  error
#    ...                                                          ${headerAuth}  ${authorization}
#    should be equal as strings  ${errorMessage}  invalid_reference_number
#
#Incorrect reference number
#    create session  emerald-api-staging  ${apiServer}
#    ${headers}=  create dictionary  ${headerRefNum}=${incorrectRefNum}  ${headerAuth}=${authorization}
#    ${resp}=  get request  emerald-api-staging  /api/words/retrieve  headers=${headers}
#    should be equal as strings  ${resp.status_code}  401
#    ${errorMessage}=  get json incomplete error attribute value  ${apiServer}  /api/words/retrieve  message
#    ...                                                          ${headerAuth}  ${authorization}  ${headerRefNum}
#    ...                                                          ${incorrectRefNum}
#    should be equal as strings  ${errorMessage}  You provided an invalid reference number.
#    ${errorMessage}=  get json incomplete error attribute value  ${apiServer}  /api/words/retrieve  error
#    ...                                                          ${headerAuth}  ${authorization}  ${headerRefNum}
#    ...                                                          ${incorrectRefNum}
#    should be equal as strings  ${errorMessage}  invalid_reference_number
#
#Without authorization
#    create session  emerald-api-staging  ${apiServer}
#    ${headers}=  create dictionary  ${headerRefNum}=${refNum}
#    ${resp}=  get request  emerald-api-staging  /api/words/retrieve  headers=${headers}
#    should be equal as strings  ${resp.status_code}  401
#    ${errorMessage}=  get json incomplete error attribute value  ${apiServer}  /api/words/retrieve  message
#    ...                                                          ${headerRefNum}  ${refNum}
#    should be equal as strings  ${errorMessage}  No description available for this error.
#    ${errorMessage}=  get json incomplete error attribute value  ${apiServer}  /api/words/retrieve  id
#    ...                                                          ${headerRefNum}  ${refNum}
#    should be equal as strings  ${errorMessage}  unauthorized
#
#Incomplete authorization
#    create session  emerald-api-staging  ${apiServer}
#    ${headers}=  create dictionary  ${headerAuth}=${incompleteAuth}
#    ${resp}=  get request  emerald-api-staging  /api/words/retrieve  headers=${headers}
#    should be equal as strings  ${resp.status_code}  401
#    ${errorMessage}=  get json incomplete error attribute value  ${apiServer}  /api/words/retrieve  message
#    ...                                                          ${headerAuth}  ${incompleteAuth}
#    should be equal as strings  ${errorMessage}  You provided an API key that does not exist.
#    ${errorMessage}=  get json incomplete error attribute value  ${apiServer}  /api/words/retrieve  error
#    ...                                                          ${headerAuth}  ${incompleteAuth}
#    should be equal as strings  ${errorMessage}  invalid_api_key

With valid authorization and reference number
    create session  emerald-api-staging  ${apiServer}
#    ${headers}=  create dictionary  ${headerRefNum}=${refNum}  ${headerAuth}=${authorization}
#    ${resp}=  get request  emerald-api-staging  /api/words/retrieve  headers=${headers}
#    should be equal as strings  ${resp.status_code}  200
    set request header  ${headerRefNum}  ${refNum}
    set request header  ${headerAuth}  ${authorization}
    HttpLibrary.HTTP.GET  /api/words/retrieve
    ${body}=  get response body
    ${status}=  get response status
    json value should equal  ${body}  /last_word  "parelease"
    check status if 200 OK  ${status}

*** Keywords ***
check status if 200 OK
    [Arguments]  ${actualStatus}
    should be equal as strings  ${actualStatus}  200 OK