import urllib2
import xlrd
import json
import pandas as pd
from datetime import datetime, timedelta, date
import calendar
import pprint

#_JSON RESPONSE_
def clean_attribute_value(raw_value):
    # Sample raw_value = [u'Email not registered.']
    # Count the raw_value length, remove the first three and last two char to extract the message only
    return str(raw_value)[3:len(str(raw_value)) - 2]

def get_specific_nested_attribute_value(response, parent_attribute, child_attribute):
    return clean_attribute_value(json.loads(response)[parent_attribute][child_attribute])

def get_specific_data_attribute_value(response, attribute):
    return json.loads(response)['data'][attribute]

def store_json_response_data_as_dictionary(response):
    return json.loads(response)['data'][0]

def compare_dictionaries(actual_dictionary, expected_dictionary):
    d1_keys = set(actual_dictionary.keys())
    d2_keys = set(expected_dictionary.keys())
    intersect_keys = d1_keys.intersection(d2_keys)
    unexpected_actual = d1_keys - d2_keys
    missing_expected = d2_keys - d1_keys
    different_values = {o: (actual_dictionary[o], expected_dictionary[o]) for o in intersect_keys
                        if actual_dictionary[o] !=expected_dictionary[o]}
    same_values = set(o for o in intersect_keys if actual_dictionary[o] == expected_dictionary[o])

    if not(unexpected_actual == set([])):
        raise ValueError('Unexpected actual attribute/s found: ', unexpected_actual)

    if not(missing_expected == set([])):
        raise ValueError('Missing expected attribute/s: ', missing_expected)

    if not(different_values == {}):
        raise ValueError('Actual and expected attribute values do not match: ', different_values)

    if not(len(same_values) == len(expected_dictionary)):
        raise ValueError('Only the following attributes matched: ', same_values)

def get_specific_nested_json_data_attribute(response, parent_attribute, child_attribute):
    return json.loads(response)['data'][parent_attribute][child_attribute]

def split_and_store_attribute_list(list):
    attribute_list = []
    attributes = list.split()
    for attribute in attributes:
        attribute_list.append(attribute)
    return attribute_list

def check_if_specific_data_key_exists(data, attribute_list, index):
    expected = str(attribute_list[index])
    found = False
    for key in data:
        if str(key) == expected:
            found = True
    if found == False:
        raise ValueError('Attribute ', expected, ' does not exist on the response!', data)

def check_if_specific_data_attribute_exists(data, attribute_list, index):
    expected = str(attribute_list[index])
    found = False

    if any(expected in key for key in data):
        found = True
    if found == False:
        raise ValueError('Attribute ', expected, ' does not exist on the response!', data)

def get_month_days_count(date_preset):
    if date_preset == "last_month":
        return str(calendar.monthrange(datetime.now().year,datetime.now().month-1)[1])
    elif date_preset == "this_month":
        return str(datetime.now().day)

def get_date_preset_count(date_preset):
    # switcher = {
    #     "today": "1",
    #     "yesterday": "1",
    #     "last_3d": "3",
    #     "last_7d": "7",
    #     "last_14d": "14",
    #     "last_28d": "28",
    #     "last_30d": "30",
    #     "last_month": get_month_days_count(date_preset),
    #     "this_month": get_month_days_count(date_preset)
    # }
    # return switcher.get(date_preset, "Invalid date preset!")

    if date_preset == "today" or date_preset == "yesterday":
        return 1
    elif date_preset == "last_3d":
        return 3
    elif date_preset == "last_7d":
        return 7
    elif date_preset == "last_14d":
        return 14
    elif date_preset == "last_28d":
        return 28
    elif date_preset == "last_30d":
        return 30
    elif date_preset == "last_month":
        return get_month_days_count(date_preset)
    elif date_preset == "this_month":
        return get_month_days_count(date_preset)
    else:
        raise ValueError('Value ', date_preset, ' is not a valid date_preset!')

def loop_check_and_store_attributes(response, attribute_list, date_preset):
    date_preset_count = get_date_preset_count(str(date_preset.encode("utf-8")))
    length = 1
    index = 0
    data = json.loads(response)['data']
    datetime_stamp_values = []
    kpi_values = []

    for count in range(0, int(date_preset_count)):
        while int(length) <= len(attribute_list):
            # check if each data attribute exists
            check_if_specific_data_attribute_exists(data, attribute_list, index)

            # get and store each attribute count
            datetime_stamp_values.append(json.loads(response)['data'][index]['datetime_stamp'])
            kpi_values.append(json.loads(response)['data'][index]['aggregated_likes_kpi_value'])

            length = length + 1
            index = index + 1
    return date_preset_count, datetime_stamp_values, kpi_values

def daterange(date1, date2):
    for n in range(int((date2 - date1).days) + 1):
        yield date1 + timedelta(n)

def get_last_month_or_this_month_days_list(date_preset, current_month):
    expected_datetime_list = []
    # get number of days
    if date_preset == "last_month":
        month_count = current_month - 1
        total_days_count = calendar.monthrange(datetime.now().year, current_month - 1)[1]
    elif date_preset == "this_month":
        month_count = current_month
        total_days_count = datetime.now().day

    # create list of days
    start_dt = date(datetime.now().year, month_count, 1)
    end_dt = date(datetime.now().year, month_count, total_days_count)
    for dt in daterange(start_dt, end_dt):
        expected_datetime_list.append(dt)
    return expected_datetime_list

def create_datetime_list(date_preset, date_preset_count):
    expected_datetime_list = []
    current_month = datetime.now().month
    if date_preset not in ("last_month", "this_month", "today", "yesterday"):
        for count in range(1, (date_preset_count+1)):
            expected_datetime_list.append(datetime.now() - timedelta(days=count))
    elif date_preset == "last_month":
        expected_datetime_list = get_last_month_or_this_month_days_list(date_preset, current_month)
    elif date_preset == "this_month":
        expected_datetime_list = get_last_month_or_this_month_days_list(date_preset, current_month)
    return expected_datetime_list

def create_kpi_list(date_preset, date_preset_count, kpi_value):
    expected_kpi_list = []
    current_month = datetime.now().month
    if date_preset == "last_month":
        date_preset_count = calendar.monthrange(datetime.now().year, current_month - 1)[1]
    elif date_preset == "this_month":
        date_preset_count = datetime.now().day

    for count in range(1, (date_preset_count + 1)):
        expected_kpi_list.append(kpi_value * count)
    return expected_kpi_list

def convert_to_timestamp(timestamp):
    return datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d')
    # value = datetime.fromtimestamp(timestamp)
    # return value.strftime('%Y-%m-%d')

def check_and_store_nested_attributes(response, attribute_list):
    length = 1
    index = 0
    data = json.loads(response)['data']

    count_values = []
    actual_percentage_values = []
    formatted_percentage_values = []

    while int(length) <= len(attribute_list):
        # check if each data attribute exists
        check_if_specific_data_key_exists(data, attribute_list, index)

        # get and store each attribute count
        count = get_specific_nested_json_data_attribute(response, attribute_list[index], 'count')
        percentage = get_specific_nested_json_data_attribute(response, attribute_list[index], 'percentage')
        formatted_percentage = get_specific_nested_json_data_attribute(response, attribute_list[index],
                                                                       'formatted_percentage')
        count_values.append(count)
        actual_percentage_values.append(percentage)
        formatted_percentage_values.append(formatted_percentage)

        length = length + 1
        index = index + 1

    return count_values, actual_percentage_values, formatted_percentage_values

def compute_breakdown_percentages(count_values, attribute_list):
    # get each percentage and check if sum is 100
    total = sum(count_values)
    length = 1
    index = 0
    computed_percentage_values = []
    while int(length) <= len(attribute_list):
        computed_percentage = 100 * float(count_values[index]) / float(total)
        computed_percentage_values.append(computed_percentage)
        length = length + 1
        index = index + 1
    if not(sum(computed_percentage_values) == 100):
        raise ValueError('Total percentage ', sum(computed_percentage_values), ' is not equal to 100!')
    return computed_percentage_values

def roundoff_list_values(list_data):
    return ['%.2f' % elem for elem in list_data]

def compare_breakdown_percentages(attribute_list, actual_percentage_values, computed_percentage_values):
    #store computed percentages in dictionary
    computed_dictionary = dict(zip(attribute_list, roundoff_list_values(computed_percentage_values)))
    #store actual percentages in dictionary
    actual_dictionary = dict(zip(attribute_list, roundoff_list_values(actual_percentage_values)))
    #compare actual and computed percentage values
    compare_dictionaries(actual_dictionary, computed_dictionary)

def compute_and_check_count(response, attribute_list):
    # get each count and check if sum is 100
    length = 1
    index = 0
    count_values = []
    while int(length) <= len(attribute_list):
        count_values.append(get_specific_data_attribute_value(response, attribute_list[index]))
        length = length + 1
        index = index + 1
    if not(sum(count_values) == 100):
        raise ValueError('Total percentage ', sum(count_values), ' is not equal to 100!')

#_EXCEL DATA_
def get_specific_value_from_data_framework(file_name, sheet_name, column_header):
    sheet_data = pd.read_excel(file_name, sheet_name=sheet_name)
    return sheet_data.ix[0, column_header]

def split_data(original_value):
    first_value, second_value = original_value.split(' ')
    return (first_value, second_value)

def open_workbook_by_sheet_index(file_path, sheet_index):
    return xlrd.open_workbook(file_path).sheet_by_index(int(sheet_index))

def store_excel_values_as_dictionary(file_path, sheet_index, start_index):
    excel_dictionary = {}
    sheet = open_workbook_by_sheet_index(file_path, sheet_index)

    while int(start_index) <= sheet.ncols-1:
        column_header = sheet.cell(0, int(start_index)).value
        column_value = sheet.cell(1, int(start_index)).value
        if(column_header == 'tagger_id'):
            column_value = str(int(column_value))
        excel_dictionary[column_header] = column_value
        start_index = int(start_index) + 1
    return excel_dictionary

#_OTHERS_
def get_json_error_attribute_value(server, link, attribute):
    url = server + link
    try:
        request = urllib2.Request(url)
        response = urllib2.urlopen(request)
    except urllib2.HTTPError as e:
        error_body = e.read()
        resp_dict = json.loads(error_body)
        return resp_dict.get(attribute)

