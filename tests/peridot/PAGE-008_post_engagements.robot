*** Variables ***
${SETUP_SHEET_NAME}               setup
${LOGIN_SHEET_NAME}               login
${VALID_CREDENTIALS_COLUMN}       creds_valid
${SERVER_COLUMN}                  server_staging
${CONTENT_TYPE_HEADER_COLUMN}     headerNameValue_login
${AUTH_HEADER_COLUMN}             headerName_auth
${LOGIN_ENDPOINT_COLUMN}          endpoint_login
${ENGAGEMENTS_SHEET_NAME}         pageEngagements
${ENGAGEMENTS_ENDPOINT_COLUMN}    endpoint_engagements
${PAGE_ID_COLUMN}                 page_id
${ID_DATE_FROM_COLUMN}            id_date_from
${ID_DATE_TO_COLUMN}              id_date_to
${PAGE_NAME_COLUMN}               page_name
${NAME_DATE_FROM_COLUMN}          name_date_from
${NAME_DATE_TO_COLUMN}            name_date_to
${ATTRIBUTE_LIST_COLUMN}          data_attribute_list

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
    ${RESPONSE}=  Get Response With Date Range Of Specific Page  ${AUTH_HEADER_VALUE}  ${ENGAGEMENTS_SHEET_NAME}
    ...                                                   ${ENGAGEMENTS_ENDPOINT_COLUMN}  ${PAGE_ID_COLUMN}
    ...                                                   ${ID_DATE_FROM_COLUMN}  ${ID_DATE_TO_COLUMN}
#    Check Percentage Breakdown Values                     ${RESPONSE}  ${ENGAGEMENTS_SHEET_NAME}
#    ...                                                   ${ATTRIBUTE_LIST_COLUMN}

With valid page name
   [Tags]  sanity
    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
    ${RESPONSE}=  Get Response With Date Range Of Specific Page  ${AUTH_HEADER_VALUE}  ${ENGAGEMENTS_SHEET_NAME}
    ...                                                   ${ENGAGEMENTS_ENDPOINT_COLUMN}  ${PAGE_NAME_COLUMN}
    ...                                                   ${NAME_DATE_FROM_COLUMN}  ${NAME_DATE_TO_COLUMN}
#    Check Percentage Breakdown Values                     ${RESPONSE}  ${ENGAGEMENTS_SHEET_NAME}
#    ...                                                   ${ATTRIBUTE_LIST_COLUMN}