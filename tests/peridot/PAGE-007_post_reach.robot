*** Variables ***
${SETUP_SHEET_NAME}             setup
${LOGIN_SHEET_NAME}             login
${VALID_CREDENTIALS_COLUMN}     creds_valid
${SERVER_COLUMN}                server_staging
${CONTENT_TYPE_HEADER_COLUMN}   headerNameValue_login
${AUTH_HEADER_COLUMN}           headerName_auth
${LOGIN_ENDPOINT_COLUMN}        endpoint_login
${REACH_SHEET_NAME}             pageReach
${REACH_ENDPOINT_COLUMN}        endpoint_reach
${PAGE_NAME_COLUMN}             page_name
${PAGE_ID_COLUMN}               page_id
${DATE_FROM_COLUMN}             date_from
${DATE_TO_COLUMN}               date_to
${NAME_PAGE_ID_VALUE_COLUMN}    name_page_id
${NAME_REACH_VALUE_COLUMN}      name_reach
${ID_PAGE_ID_VALUE_COLUMN}      id_page_id
${ID_REACH_VALUE_COLUMN}        id_reach
${PAGE_ID_ATTRIBUTE_COLUMN}     attribute_page_id
${REACH_ATTRIBUTE_COLUMN}       attribute_reach

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
    ${RESPONSE}=  Get Response With Date Range Of Specific Page  ${AUTH_HEADER_VALUE}  ${REACH_SHEET_NAME}
    ...                                                   ${REACH_ENDPOINT_COLUMN}  ${PAGE_ID_COLUMN}
    ...                                                   ${DATE_FROM_COLUMN}  ${DATE_TO_COLUMN}
    Compare Actual And Expected Data Attribute Value  ${RESPONSE}  ${REACH_SHEET_NAME}  ${PAGE_ID_ATTRIBUTE_COLUMN}
    ...                                      ${ID_PAGE_ID_VALUE_COLUMN}
    Compare Actual And Expected Data Attribute Value  ${RESPONSE}  ${REACH_SHEET_NAME}  ${REACH_ATTRIBUTE_COLUMN}
    ...                                      ${ID_REACH_VALUE_COLUMN}

With valid page name
   [Tags]  sanity
    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
    ${RESPONSE}=  Get Response With Date Range Of Specific Page  ${AUTH_HEADER_VALUE}  ${REACH_SHEET_NAME}
    ...                                                   ${REACH_ENDPOINT_COLUMN}  ${PAGE_NAME_COLUMN}
    ...                                                   ${DATE_FROM_COLUMN}  ${DATE_TO_COLUMN}
    Compare Actual And Expected Data Attribute Value  ${RESPONSE}  ${REACH_SHEET_NAME}  ${PAGE_ID_ATTRIBUTE_COLUMN}
    ...                                      ${NAME_PAGE_ID_VALUE_COLUMN}
    Compare Actual And Expected Data Attribute Value  ${RESPONSE}  ${REACH_SHEET_NAME}  ${REACH_ATTRIBUTE_COLUMN}
    ...                                      ${NAME_REACH_VALUE_COLUMN}