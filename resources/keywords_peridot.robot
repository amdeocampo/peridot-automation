*** Settings ***
Documentation    Keywords used across all Peridot test scripts.
Library  Collections
Library  RequestsLibrary
Library  ExcelLibrary
Library  OperatingSystem
Library  /Users/amdeocampo/Olelo/Automation/Backend/Resources/utility_backend.py

*** Variables ***
${TEST_DATA_PATH}  /Users/amdeocampo/Olelo/Automation/Backend/Files
${TEST_DATA_FILE_NAME}  testData_peridot.xls
${TEST_DATA_COMPLETE_PATH}  /Users/amdeocampo/Olelo/Automation/Backend/Resources/testData_peridot.xls

*** Keywords ***
###_EXCEL_
Get Specific Excel Data And Split
    [Arguments]  ${sheet_name}  ${column_header}
    ${credentials}=  get_specific_value_from_data_framework  ${TEST_DATA_COMPLETE_PATH}  ${sheet_name}  ${column_header}
    ${FIRST_DATA}  ${SECOND_DATA}=  split_data  ${credentials}
    [Return]  ${FIRST_DATA}  ${SECOND_DATA}

Get Specific Data From Excel Sheet
    [Arguments]  ${sheet_name}  ${column_header}
    ${VALUE}=  get_specific_value_from_data_framework  ${TEST_DATA_COMPLETE_PATH}  ${sheet_name}  ${column_header}
    [Return]  ${VALUE}

###_LOGIN_
Get Credentials
    [Arguments]  ${sheet_name}  ${creds_header}
    ${email}  ${password}=  Get Specific Excel Data And Split  ${sheet_name}  ${creds_header}
    ${CREDENTIALS}=  create dictionary   email=${email}  password=${password}
    [Return]  ${CREDENTIALS}

Get Headers
    [Arguments]  ${sheet_name}  ${login_header}
    ${login_header_name}  ${login_header_value}=  Get Specific Excel Data And Split  ${sheet_name}  ${login_header}
    ${HEADERS}=  create dictionary  ${login_header_name}=${login_header_value}
    [Return]  ${HEADERS}

Get Login Data
    [Arguments]  ${sheet_name}  ${server_header}  ${endpoint_header}
    ${ALIAS}  ${BASE_URL}=  Get Specific Excel Data And Split  ${sheet_name}  ${server_header}
    ${LOGIN_ENDPOINT}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${endpoint_header}
    [Return]  ${ALIAS}  ${BASE_URL}  ${LOGIN_ENDPOINT}

Post Login Request And Get Response
    [Arguments]  ${sheet_name}  ${creds_header}  ${server_header}  ${login_header}  ${endpoint_header}
    ${credentials}=  Get Credentials  ${sheet_name}  ${creds_header}
    ${headers}=  Get Headers  ${sheet_name}  ${login_header}
    ${alias}  ${base_url}  ${login_endpoint}=  Get Login Data  ${sheet_name}  ${server_header}  ${endpoint_header}
    create session  ${alias}  ${baseUrl}  verify=True
    ${RESPONSE}=  post request  ${alias}  ${login_endpoint}  data=${credentials}  headers=${headers}
    [Return]  ${RESPONSE}

Login To Peridot And Get Auth
    [Arguments]  ${sheet_name}  ${creds_header}  ${server_header}  ${login_header}  ${endpoint_header}
    ${credentials}=  Get Credentials  ${sheet_name}  ${creds_header}
    ${headers}=  Get Headers  ${sheet_name}  ${login_header}
    ${ALIAS}  ${baseUrl}  ${login_endpoint}=  Get Login Data  ${sheet_name}  ${server_header}  ${endpoint_header}
    set test variable  ${ALIAS}
    create session  ${alias}  ${baseUrl}  verify=True
    ${response}=  post request  ${alias}  ${login_endpoint}  data=${credentials}  headers=${headers}
    Check Response Status Code  ${response.status_code}  200
    Check If Response Has Specific Attribute  ${response}  auth_token
    ${json_data}=  to json  ${response.content}  pretty_print=True
    ${AUTH_TOKEN}=  get_specific_data_attribute_value  ${json_data}  auth_token
    [Return]  ${AUTH_TOKEN}

Post Login Request With Missing Credentials
    [Arguments]  ${sheet_name}  ${email}  ${password}  ${server_header}  ${login_header}  ${endpoint_header}
    ${credentials}=  create dictionary  email=${email}  password=${password}
    ${headers}=  Get Headers  ${sheet_name}  ${login_header}
    ${alias}  ${base_url}  ${login_endpoint}=  Get Login Data  ${sheet_name}  ${server_header}  ${endpoint_header}
    create session  ${alias}  ${base_url}  verify=True
    ${RESPONSE}=  post request  ${alias}  ${login_endpoint}  data=${credentials}  headers=${headers}
    [Return]  ${RESPONSE}

Post Login Request Without Header
    [Arguments]  ${sheet_name}  ${creds_header}  ${server_header}  ${endpoint_header}
    ${credentials}=  Get Credentials  ${sheet_name}  ${creds_header}
    ${alias}  ${base_url}  ${login_endpoint}=  Get Login Data  ${sheet_name}  ${server_header}  ${endpoint_header}
    create session  ${alias}  ${base_url}  verify=True
    ${RESPONSE}=  post request  ${alias}  ${login_endpoint}  data=${credentials}
    [Return]  ${RESPONSE}

###_PAGES_
#_MENTIONS_
Check Mentions Details
    [Arguments]  ${response}  ${sheet_index}  ${start_index}
    ${actual_values}=  store_json_response_data_as_dictionary  ${response.content}
    ${expected_values}=  store_excel_values_as_dictionary  ${TEST_DATA_COMPLETE_PATH}  ${sheet_index}  ${start_index}
    compare_dictionaries  ${actual_values}  ${expected_values}

#_GET_DATA_ATTRIBUTE_VALUES_AND_COMPARE_
Compare Actual And Expected Data Attribute Value
    [Arguments]  ${response}  ${sheet_name}  ${current_total_header}  ${expected_total_count_header}
    ${data_attribute}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${current_total_header}
    ${json_data}=  to json  ${response.content}  pretty_print=True
    ${actual_value}=  get_specific_data_attribute_value  ${json_data}  ${data_attribute}
    ${expected_value}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${expected_total_count_header}
    should be equal as strings  ${actual_value}  ${expected_value}

#_GET RESPONSE OF SPECIFIC PAGE_
Get Response Of Specific Page
    [Arguments]  ${auth_header_value}  ${sheet_name}  ${likes_endpoint_column}  ${page_column}
    ${likes_endpoint}  ${page}=  Get Payload Values  ${sheet_name}  ${likes_endpoint_column}  ${page_column}
    ${auth_header}=  create dictionary  Authorization=${auth_header_value}
    ${payload}=  create dictionary  page_id=${page}
    ${RESPONSE}=  get request  ${ALIAS}  ${likes_endpoint}  params=${payload}  headers=${auth_header}
    Check Response Status Code  ${response.status_code}  200
    [Return]  ${RESPONSE}

#_GET_RESPONSE_WITH_SPECIFIC_DATE_RANGE
Get Response With Date Range Of Specific Page
    [Arguments]  ${auth_header_value}  ${sheet_name}  ${endpoint_column}  ${page_column}  ${date_from_column}
    ...          ${date_to_column}
    ${endpoint}  ${page}  ${date_from}  ${date_to}=  Get Payload Values With Date Range  ${sheet_name}
    ...                                                     ${endpoint_column}  ${page_column}
    ...                                                     ${date_from_column}  ${date_to_column}
    ${auth_header}=  create dictionary  Authorization=${auth_header_value}
    ${payload}=  create dictionary  page_id=${page}  date_from=${date_from}  date_to=${date_to}
    ${RESPONSE}=  get request  ${ALIAS}  ${endpoint}  params=${payload}  headers=${auth_header}
#    ${json_data}=  to json  ${response.content}  pretty_print=True
#    log to console  ${json_data}
    Check Response Status Code  ${response.status_code}  200
    [Return]  ${RESPONSE}

#_GET_RESPONSE_WITH_SEPCIFIC_DATE_PRESET
Get Response Of Specific Page With Date Preset
    [Arguments]  ${auth_header_value}  ${sheet_name}  ${endpoint_column}  ${page_column}  ${date_preset_column}
    ${endpoint}  ${page}  ${date_preset}=  Get Payload Values With Date Preset  ${sheet_name}
    ...                                                     ${endpoint_column}  ${page_column}  ${date_preset_column}
    ${auth_header}=  create dictionary  Authorization=${auth_header_value}
    ${payload}=  create dictionary  page_id=${page}  date_preset=${date_preset}
    ${RESPONSE}=  get request  ${ALIAS}  ${endpoint}  params=${payload}  headers=${auth_header}
#    ${json_data}=  to json  ${response.content}  pretty_print=True
#    log to console  ${json_data}
    Check Response Status Code  ${response.status_code}  200
    [Return]  ${RESPONSE}

#_PERCENTAGE BREAKDOWN_
Check Percentage Breakdown Values
    [Arguments]  ${response}  ${sheet}  ${attribute_list_column}
    ${json_data}=  to json  ${response.content}  pretty_print=True
    ${expected_list}=  Get Specific Data From Excel Sheet  ${sheet}  ${attribute_list_column}
    ${attribute_list}=  split_and_store_attribute_list  ${expected_list}
    ${count_values}  ${actual_percentage_values}  ${formatted_percentage_values}=  check_and_store_nested_attributes
    ...                                                                            ${json_data}  ${attribute_list}
    ${computed_percentage_values}=  compute_breakdown_percentages  ${count_values}  ${attribute_list}
    compare_breakdown_percentages  ${attribute_list}  ${actual_percentage_values}  ${computed_percentage_values}
    compare_breakdown_percentages  ${attribute_list}  ${formatted_percentage_values}  ${computed_percentage_values}

#_COUNT_BREAKDOWN_
Check Count Breakdown Values
    [Arguments]  ${response}  ${sheet}  ${attribute_list_column}
    ${json_data}=  to json  ${response.content}  pretty_print=True
    ${expected_list}=  Get Specific Data From Excel Sheet  ${sheet}  ${attribute_list_column}
    ${attribute_list}=  split_and_store_attribute_list  ${expected_list}
    compute_and_check_count  ${json_data}  ${attribute_list}

#_ENGAGEMENTS_
Check Post Engagements Values
    [Arguments]  ${response}  ${sheet}  ${attribute_list_column}
    ${json_data}=  to json  ${response.content}  pretty_print=True
    ${expected_attribute_list}=  Get Specific Data From Excel Sheet  ${sheet}  ${attribute_list_column}
    ${attribute_list}=  split_and_store_attribute_list  ${expected_attribute_list}
    ${count_values}  ${actual_percentage_values}  ${formatted_percentage_values}=  check_and_store_nested_attributes
    ...                                                                            ${json_data}  ${attribute_list}
    ${computed_percentage_values}=  compute_breakdown_percentages  ${count_values}  ${attribute_list}
    compare_breakdown_percentages  ${attribute_list}  ${actual_percentage_values}  ${computed_percentage_values}
    compare_breakdown_percentages  ${attribute_list}  ${formatted_percentage_values}  ${computed_percentage_values}

#_AGGREGATED_LIKES_
Check Aggregated Likes Details
    [Arguments]  ${response}  ${sheet}  ${date_preset_column}  ${attribute_list_column}  ${kpi_value}
    ${json_data}=  to json  ${response.content}  pretty_print=True
    ${expected_attribute_list}=  Get Specific Data From Excel Sheet  ${sheet}  ${attribute_list_column}
    ${attribute_list}=  split_and_store_attribute_list  ${expected_attribute_list}
    ${date_preset}=  Get Specific Data From Excel Sheet  ${sheet}  ${date_preset_column}
    ${date_preset_count}  ${actual_datetime_list}  ${actual_kpi_list}=  loop_check_and_store_attributes  ${json_data}
    ...                                                                 ${attribute_list}  ${date_preset}
#    get expected datetime
    ${expected_datetime_list}=  create_datetime_list  ${date_preset}  ${date_preset_count}
    log to console  ${expected_datetime_list}
    #get expected kpi
#    ${expected_kpi_list}=  create_kpi_list  ${date_preset}
    #compare actual and expected datetime
    #compare actual and expected kpi

#_GENERAL_
Check If Response Has Specific Attribute
    [Arguments]  ${response}  ${attribute}
    ${json_data}=  to json  ${response.content}  pretty_print=True
    should contain  ${json_data}  ${attribute}

Check Specific Error Message
    [Arguments]  ${response}  ${attribute}  ${sheet_name}  ${error_header}
    ${json_data}=  to json  ${response.content}  pretty_print=True
    ${actual_error_message}=  get_specific_nested_attribute_value  ${json_data}  error  ${attribute}
    ${expected_error_message}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${error_header}
    should contain  ${actual_error_message}  ${expected_error_message}

Check Response Status Code
    [Arguments]  ${actualStatus}  ${expectedStatus}
    should be equal as strings  ${actualStatus}  ${expectedStatus}

Get Payload Values
    [Arguments]  ${sheet_name}  ${endpoint_column}  ${page_column}
    ${ENDPOINT}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${endpoint_column}
    ${PAGE}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${page_column}
    [Return]  ${ENDPOINT}  ${PAGE}

Get Payload Values With Date Range
    [Arguments]  ${sheet_name}  ${endpoint_column}  ${page_column}  ${date_from_column}
    ...          ${date_to_column}
    ${ENDPOINT}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${endpoint_column}
    ${PAGE}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${page_column}
    ${DATE_FROM}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${date_from_column}
    ${DATE_TO}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${date_to_column}
    [Return]  ${ENDPOINT}  ${PAGE}  ${DATE_FROM}  ${DATE_TO}

Get Payload Values With Date Preset
    [Arguments]  ${sheet_name}  ${endpoint_column}  ${page_column}  ${date_preset_column}
    ${ENDPOINT}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${endpoint_column}
    ${PAGE}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${page_column}
    ${DATE_PRESET}=  Get Specific Data From Excel Sheet  ${sheet_name}  ${date_preset_column}
    [Return]  ${ENDPOINT}  ${PAGE}  ${DATE_PRESET}