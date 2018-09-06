*** Settings ***
Library  Collections
Library  RequestsLibrary

*** Test Cases ***
Get Requests
#    create session  github  http://api.github.com
    create session  google  http://google.com
    ${resp}=    get request  google  /
    should be equal as strings  ${resp.status_code}  200
#    ${resp}=    get request  github  /users/bulkan
#    should be equal as strings  ${resp.status_code}  200
#    dictionary should contain value  ${resp.json()}  Bulkan Savun Evcimen