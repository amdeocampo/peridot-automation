*** Variables ***
${SETUP_SHEET_NAME}             setup
${LOGIN_SHEET_NAME}             login
${VALID_CREDENTIALS_COLUMN}     creds_valid
${SERVER_COLUMN}                server_staging
${CONTENT_TYPE_HEADER_COLUMN}   headerNameValue_login
${AUTH_HEADER_COLUMN}           headerName_auth
${LOGIN_ENDPOINT_COLUMN}        endpoint_login
${REACTIONS_SHEET_NAME}         pageReactions
${REACTIONS_ENDPOINT_COLUMN}    endpoint_reactions
${PAGE_NAME_COLUMN}             page_name
${PAGE_ID_COLUMN}               page_id
${DATE_FROM_COLUMN}             date_from
${DATE_TO_COLUMN}               date_to
${REACTIONS_LIST_COLUMN}        reactions_list

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
    ${RESPONSE}=  Get Response With Date Range Of Specific Page  ${AUTH_HEADER_VALUE}  ${REACTIONS_SHEET_NAME}
    ...                                                   ${REACTIONS_ENDPOINT_COLUMN}  ${PAGE_ID_COLUMN}
    ...                                                   ${DATE_FROM_COLUMN}  ${DATE_TO_COLUMN}
    Check Percentage Breakdown Values                     ${RESPONSE}  ${REACTIONS_SHEET_NAME}  ${REACTIONS_LIST_COLUMN}

With valid page name
   [Tags]  sanity
    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
    ${RESPONSE}=  Get Response With Date Range Of Specific Page  ${AUTH_HEADER_VALUE}  ${REACTIONS_SHEET_NAME}
    ...                                                   ${REACTIONS_ENDPOINT_COLUMN}  ${PAGE_NAME_COLUMN}
    ...                                                   ${DATE_FROM_COLUMN}  ${DATE_TO_COLUMN}
    Check Percentage Breakdown Values                     ${RESPONSE}  ${REACTIONS_SHEET_NAME}  ${REACTIONS_LIST_COLUMN}