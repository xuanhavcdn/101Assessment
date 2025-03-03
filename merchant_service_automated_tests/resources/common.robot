*** Settings ***
Library    ExcelLibrary
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Variables    ../variables/url.py
*** Variables ***
&{headers}    Content-Type=application/json    Accept=application/json
${excelFilePath}    merchant_service_automated_tests/test_data/test_data.xlsx 
${refreshTokenSheetName}    Refresh_Token

*** Keywords ***
Read Excel Data
    [Arguments]    ${file_path}    ${sheet_name}    ${row}
    Open Excel Document    ${file_path}    doc_id=excel_doc
    ${data}=    Read Excel Row    ${row}    sheet_name=${sheet_name}
    Close Current Excel Document
    RETURN    ${data}

Get Token Using Refresh Token
    # Read data from Excel file
    ${excel_data}=    Read Excel Data    ${excelFilePath}    ${refreshTokenSheetName}    2
    # Set variables
    ${clientId}=    Set Variable    ${excel_data}[0]
    ${redirectUri}=    Set Variable    ${excel_data}[1]   
    ${grantType}=    Set Variable    ${excel_data}[2]    
    ${refreshToken}=    Set Variable    ${excel_data}[3]

    
    # Create the request body dynamically
    &{BODY}=    Create Dictionary
    ...    clientId=${clientId}
    ...    redirectUri=${redirectUri}
    ...    grantType=${grantType}
    ...    refreshToken=${refreshToken}
    # Make the API request
    Create Session    identity_service    ${apiTokenUrl}
    ${response}=    Post On Session    identity_service    /    headers=${headers}    json=${BODY}

    ${response_json}=    Evaluate    json.loads($response.content)    json
    ${id_token}=    Get Value From Json    ${response_json}    $.id_token
    Set Test Variable    ${ACCESS_TOKEN}    ${id_token}[0]
    RETURN    ${ACCESS_TOKEN}

# Common requests
I send a GET request to ${functionName} with ${urlPath}, params ${params} and expected status ${status}
    ${HEADERS}=    Create Dictionary    Content-Type=application/json    Authorization=${ACCESS_TOKEN}
    Create Session    host    ${host}
    ${response}=    GET On Session    host    ${urlPath}    headers=${HEADERS}    expected_status=${status}    params=${params}
    Set Test Variable    ${RESPONSE}    ${response}

I send a POST request to ${functionName} with ${urlPath}, payload ${payload} and expected status ${status}
    ${HEADERS}=    Create Dictionary    Content-Type=application/json    Authorization=${ACCESS_TOKEN}
    Create Session    host    ${host}
    ${response}=    POST On Session    host    ${urlPath}    headers=${HEADERS}    json=${payload}    expected_status=${status}
    Set Test Variable    ${RESPONSE}    ${response}

I send a PUT request to ${functionName} with ${urlPath}, payload ${payload} and expected status ${status}
    ${HEADERS}=    Create Dictionary    Content-Type=application/json    Authorization=${ACCESS_TOKEN}
    Create Session    host    ${host}
    ${response}=    PUT On Session    host    ${urlPath}    headers=${HEADERS}    json=${payload}    expected_status=${status}
    Set Test Variable    ${RESPONSE}    ${response}
    