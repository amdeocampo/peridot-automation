*** Variables ***
${SETUP_SHEET_NAME}             setup
${LOGIN_SHEET_NAME}             login
${VALID_CREDENTIALS_COLUMN}     creds_valid
${SERVER_COLUMN}                server_staging
${CONTENT_TYPE_HEADER_COLUMN}   headerNameValue_login
${AUTH_HEADER_COLUMN}           headerName_auth
${LOGIN_ENDPOINT_COLUMN}        endpoint_login
${SENTIMENTS_SHEET_NAME}        pageSentiments
${SENTIMENTS_ENDPOINT_COLUMN}   endpoint_sentiments
${PAGE_NAME_COLUMN}             page_name
${PAGE_ID_COLUMN}               page_id
${SENTIMENTS_LIST_COLUMN}       sentiments_list

*** Settings ***
Library  Collections
Library  RequestsLibrary
Resource  /Users/amdeocampo/Olelo/Automation/Backend/Resources/keywords_peridot.robot

*** Test Cases ***
With valid page id
    [Tags]  sanity
    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
    ${RESPONSE}=  Get Response Of Specific Page           ${AUTH_HEADER_VALUE}  ${SENTIMENTS_SHEET_NAME}
    ...                                                   ${SENTIMENTS_ENDPOINT_COLUMN}  ${PAGE_ID_COLUMN}
    Check Count Breakdown Values                          ${RESPONSE}  ${SENTIMENTS_SHEET_NAME}  ${SENTIMENTS_LIST_COLUMN}