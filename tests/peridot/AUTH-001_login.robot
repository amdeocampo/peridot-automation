*** Variables ***
${SETUP_SHEET_NAME}  setup
${LOGIN_SHEET_NAME}  login
${VALID_CREDENTIALS_COLUMN}  creds_valid
${UNREGISTERED_EMAIL_COLUMN}  creds_email_unregistered
${INCOMPLETE_EMAIL_COLUMN}  creds_email_incomplete
${SERVER_COLUMN}  server_staging
${AUTH_HEADER_COLUMN}  headerNameValue_login
${LOGIN_ENDPOINT_COLUMN}  endpoint_login
${UNREGISTERED_EMAIL_ERROR_COLUMN}  error_unregisteredEmail
${MISSING_EMAIL_ERROR_COLUMN}  error_missingEmail
${MISSING_PASSWORD_ERROR_COLUMN}  error_missingPassword

*** Settings ***
Library  Collections
Library  RequestsLibrary
Resource  /Users/amdeocampo/Olelo/Automation/Backend/resources/keywords_peridot.robot

*** Test Cases ***
With valid email and password
    [Tags]  sanity
    ${response}=  Post Login Request And Get Response  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                                ${SERVER_COLUMN}  ${AUTH_HEADER_COLUMN}  ${LOGIN_ENDPOINT_COLUMN}
    Check If Response Has Specific Attribute  ${response}  auth_token
    Check Response Status Code  ${response.status_code}  200

With unregistered email and password
    [Tags]  regression
    ${response}=  Post Login Request And Get Response  ${SETUP_SHEET_NAME}  ${UNREGISTERED_EMAIL_COLUMN}
    ...                                                ${SERVER_COLUMN}  ${AUTH_HEADER_COLUMN}  ${LOGIN_ENDPOINT_COLUMN}
    Check Specific Error Message  ${response}  email  ${LOGIN_SHEET_NAME}  ${UNREGISTERED_EMAIL_ERROR_COLUMN}
    Check Response Status Code  ${response.status_code}  422

With incomplete email and password
    [Tags]  regression
    ${response}=  Post Login Request And Get Response  ${SETUP_SHEET_NAME}  ${INCOMPLETE_EMAIL_COLUMN}
    ...                                                ${SERVER_COLUMN}  ${AUTH_HEADER_COLUMN}  ${LOGIN_ENDPOINT_COLUMN}
    Check Specific Error Message  ${response}  email  ${LOGIN_SHEET_NAME}  ${UNREGISTERED_EMAIL_ERROR_COLUMN}
    Check Response Status Code  ${response.status_code}  422

Without email
    [Tags]  regression
    ${response}=  Post Login Request With Missing Credentials  ${SETUP_SHEET_NAME}  ${EMPTY}  password
    ...                                                ${SERVER_COLUMN}  ${AUTH_HEADER_COLUMN}  ${LOGIN_ENDPOINT_COLUMN}
    Check Specific Error Message  ${response}  email  ${LOGIN_SHEET_NAME}  ${MISSING_EMAIL_ERROR_COLUMN}
    Check Response Status Code  ${response.status_code}  422

Without password
    [Tags]  regression
    ${response}=  Post Login Request With Missing Credentials  ${SETUP_SHEET_NAME}  email  ${EMPTY}
    ...                                                ${SERVER_COLUMN}  ${AUTH_HEADER_COLUMN}  ${LOGIN_ENDPOINT_COLUMN}
    Check Specific Error Message  ${response}  password  ${LOGIN_SHEET_NAME}  ${MISSING_PASSWORD_ERROR_COLUMN}
    Check Response Status Code  ${response.status_code}  422

Without header
    [Tags]  regression
    ${response}=  Post Login Request Without Header  ${SETUP_SHEET_NAME}  ${VALID_CREDENTIALS_COLUMN}
    ...                                              ${SERVER_COLUMN}  ${LOGIN_ENDPOINT_COLUMN}
    Check Specific Error Message  ${response}  email  ${LOGIN_SHEET_NAME}  ${MISSING_EMAIL_ERROR_COLUMN}
    Check Specific Error Message  ${response}  password  ${LOGIN_SHEET_NAME}  ${MISSING_PASSWORD_ERROR_COLUMN}
    Check Response Status Code  ${response.status_code}  422