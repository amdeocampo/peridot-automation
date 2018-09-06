*** Variables ***
${SETUP_SHEET_NAME}  setup
${LOGIN_SHEET_NAME}  login
${MENTIONS_USER_SHEET_NAME}  mentionsUser
${MENTIONS_PAGE_SHEET_NAME}  mentionsPage
${VALID_CREDENTIALS_COLUMN}  creds_valid
${SERVER_COLUMN}  server_staging
${CONTENT_TYPE_HEADER_COLUMN}  headerNameValue_login
${AUTH_HEADER_COLUMN}  headerName_auth
${LOGIN_ENDPOINT_COLUMN}  endpoint_login
${MENTIONS_ENDPOINT_COLUMN}  endpoint_mentions
${PAGE_NAME_COLUMN}  page_name
${PAGE_ID_COLUMN}  page_id
${DATE_FROM_COLUMN}  date_from
${DATE_TO_COLUMN}  date_to
${MENTIONS_USER_SHEET_INDEX}  3
${MENTIONS_PAGE_SHEET_INDEX}  4
${COLUMN_START_INDEX}  4

*** Settings ***
Library  Collections
Library  RequestsLibrary
Resource  /Users/amdeocampo/Olelo/Automation/Backend/Resources/keywords_peridot.robot

*** Test Cases ***
With valid page id and date range
    [Tags]  sanity
    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
    ${RESPONSE}=  Get Response With Date Range Of Specific Page  ${AUTH_HEADER_VALUE}  ${MENTIONS_USER_SHEET_NAME}
    ...                                                   ${MENTIONS_ENDPOINT_COLUMN}  ${PAGE_ID_COLUMN}
    ...                                                   ${DATE_FROM_COLUMN}  ${DATE_TO_COLUMN}
    Check Mentions Details  ${RESPONSE}  ${MENTIONS_USER_SHEET_INDEX}  ${COLUMN_START_INDEX}

With valid page name and date range
   [Tags]  sanity
    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
    ${RESPONSE}=  Get Response With Date Range Of Specific Page  ${AUTH_HEADER_VALUE}  ${MENTIONS_PAGE_SHEET_NAME}
    ...                                                   ${MENTIONS_ENDPOINT_COLUMN}  ${PAGE_NAME_COLUMN}
    ...                                                   ${DATE_FROM_COLUMN}  ${DATE_TO_COLUMN}
    Check Mentions Details  ${RESPONSE}  ${MENTIONS_PAGE_SHEET_INDEX}  ${COLUMN_START_INDEX}