*** Variables ***
${SETUP_SHEET_NAME}                  setup
${LOGIN_SHEET_NAME}                  login
${AGGREGATED_LIKES_SHEET_NAME}       aggregatedLikes
${VALID_CREDENTIALS_COLUMN}          creds_valid
${SERVER_COLUMN}                     server_staging
${CONTENT_TYPE_HEADER_COLUMN}        headerNameValue_login
${AUTH_HEADER_COLUMN}                headerName_auth
${LOGIN_ENDPOINT_COLUMN}             endpoint_login
${AGGREGATED_LIKES_ENDPOINT_COLUMN}  endpoint_aggregatedLikes
${PAGE_NAME_COLUMN}                  page_name
${NAME_DATE_PRESET_COLUMN}           name_date_preset
${NAME_KPI_VALUE_COLUMN}             name_kpi_value
${PAGE_ID_COLUMN}                    page_id
${ID_DATE_PRESET_COLUMN}             id_date_preset
${ID_KPI_VALUE_COLUMN}               id_kpi_value
${ATTRIBUTE_LIST_COLUMN}             data_attribute_list

*** Settings ***
Library  Collections
Library  RequestsLibrary
Resource  /Users/amdeocampo/Olelo/Automation/Backend/Resources/keywords_peridot.robot

*** Test Cases ***
With valid page id and date preset
    [Tags]  sanity
    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
    ${RESPONSE}=  Get Response Of Specific Page With Date Preset  ${AUTH_HEADER_VALUE}  ${AGGREGATED_LIKES_SHEET_NAME}
    ...                                                   ${AGGREGATED_LIKES_ENDPOINT_COLUMN}  ${PAGE_ID_COLUMN}
    ...                                                   ${ID_DATE_PRESET_COLUMN}
    Check Aggregated Likes Details  ${RESPONSE}  ${AGGREGATED_LIKES_SHEET_NAME}  ${ID_DATE_PRESET_COLUMN}
    ...                             ${ATTRIBUTE_LIST_COLUMN}  ${ID_KPI_VALUE_COLUMN}

#With valid page name and date preset
#   [Tags]  sanity
#    ${AUTH_HEADER_VALUE}=  Login To Peridot And Get Auth  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
#    ...                                                   ${SERVER_COLUMN}  ${CONTENT_TYPE_HEADER_COLUMN}
#    ...                                                   ${LOGIN_ENDPOINT_COLUMN}
#    ${RESPONSE}=  Get Response Of Specific Page With Date Preset  ${AUTH_HEADER_VALUE}  ${AGGREGATED_LIKES_SHEET_NAME}
#    ...                                                   ${AGGREGATED_LIKES_ENDPOINT_COLUMN}  ${PAGE_NAME_COLUMN}
#    ...                                                   ${NAME_DATE_PRESET_COLUMN}
#    Check Aggregated Likes Details  ${RESPONSE}  ${AGGREGATED_LIKES_SHEET_NAME}  ${NAME_DATE_PRESET_COLUMN}
#    ...                             ${ATTRIBUTE_LIST_COLUMN}  ${NAME_KPI_VALUE_COLUMN}