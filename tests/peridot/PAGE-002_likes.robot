*** Variables ***
${SETUP_SHEET_NAME}  setup
${LOGIN_SHEET_NAME}  login
${VALID_CREDENTIALS_COLUMN}  creds_valid
${SERVER_COLUMN}  server_staging
${CONTENT_TYPE_HEADER_COLUMN}  headerNameValue_login
${AUTH_HEADER_COLUMN}  headerName_auth
${LOGIN_ENDPOINT_COLUMN}  endpoint_login
${LIKES_SHEET_NAME}  pageLikes
${LIKES_ENDPOINT_COLUMN}  endpoint_likes
${PAGE_ID_COLUMN}  page_id
${PAGE_ID_TOTAL_COUNT_COLUMN}  total_id
${PAGE_NAME_COLUMN}  page_name
${PAGE_NAME_TOTAL_COUNT_COLUMN}  total_name
${CURRENT_TOTAL_ATTRIBUTE_COLUMN}  attribute_currentTotal

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
    ${RESPONSE}=  Get Response Of Specific Page  ${AUTH_HEADER_VALUE}  ${LIKES_SHEET_NAME}
    ...                                                   ${LIKES_ENDPOINT_COLUMN}  ${PAGE_ID_COLUMN}
    Compare Actual And Expected Data Attribute Value  ${RESPONSE}  ${LIKES_SHEET_NAME}  ${CURRENT_TOTAL_ATTRIBUTE_COLUMN}
    ...                                      ${PAGE_ID_TOTAL_COUNT_COLUMN}

With valid page name
   [Tags]  sanity
    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
    ${RESPONSE}=  Get Response Of Specific Page  ${AUTH_HEADER_VALUE}  ${LIKES_SHEET_NAME}
    ...                                                   ${LIKES_ENDPOINT_COLUMN}  ${PAGE_NAME_COLUMN}
    Compare Actual And Expected Data Attribute Value  ${RESPONSE}  ${LIKES_SHEET_NAME}  ${CURRENT_TOTAL_ATTRIBUTE_COLUMN}
    ...                                      ${PAGE_NAME_TOTAL_COUNT_COLUMN}