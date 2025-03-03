*** Settings ***
Library    RequestsLibrary
Library    ExcelLibrary     
Library    Collections  
Resource    common.robot
Library    JSONLibrary
Library    ../../.venv/lib/python3.11/site-packages/robot/libraries/String.py

*** Variables ***
${createNewMerchantSheetName}    New_MerChant
${merchantsPath}    /merchants
*** Keywords ***
I have a valid merchant payload
    ${excel_data}=    Read Excel Data    ${excelFilePath}    ${createNewMerchantSheetName}    2
    Set Test Variable    ${baseCurrency}    ${excel_data}[0]
    Set Test Variable    ${invoicePrefix}    ${excel_data}[1]
    Set Test Variable    ${dueAfter}    ${excel_data}[2]
    Set Test Variable    ${nextInvoiceNumber}    ${excel_data}[3]
    Set Test Variable    ${mcc}    ${excel_data}[4]
    Set Test Variable    ${mccName}    ${excel_data}[5]
    Set Test Variable    ${loyaltyEligible}    ${excel_data}[6]

    &{BODY}=    Create Dictionary
        ...    baseCurrency=${baseCurrency}
        ...    invoicePrefix=${invoicePrefix}
        ...    dueAfter=${dueAfter}
        ...    nextInvoiceNumber=${nextInvoiceNumber}
        ...    mcc=${mcc}
        ...    mccName=${mccName}
        ...    loyaltyEligible=${loyaltyEligible}
        
    &{CATEGORY}=    Create Dictionary
    ...    categoryName=${excel_data}[7]
    ...    categoryCode=${excel_data}[8]
    ...    riskLevel=${excel_data}[9]
    ...    description=${excel_data}[10]
    
    Set To Dictionary    ${BODY}    category=${CATEGORY}
    Set Test Variable    ${PAYLOAD}    ${BODY}

I use an invalid access token
    Set Test Variable    ${ACCESS_TOKEN}    invalid_token

I use a valid access token
    ${token}=    Get Token Using Refresh Token
    Set Test Variable    ${ACCESS_TOKEN}    ${token}
I have a merchant payload with missing base currency
    I have a valid merchant payload
    Set To Dictionary    ${PAYLOAD}    baseCurrency=${EMPTY}

I send a POST request to create a merchant with expected status ${status}
    ${HEADERS}=    Create Dictionary    Content-Type=application/json    Authorization=${ACCESS_TOKEN}
    Create Session    host    ${host}
    ${response}=    POST On Session    host    ${merchantsPath}    headers=${HEADERS}    json=${PAYLOAD}    expected_status=${status}
    Set Test Variable    ${RESPONSE}    ${response}
    ${response_json}=    Evaluate    json.loads($RESPONSE.content)    json
    ${merchantList}=    Get Value From Json    ${response_json}    $.data.merchantId
    Run Keyword If    ${status} == 201
    ...    Set Test Variable    ${MERCHANT_ID}    ${merchantList}[0]

I have merchant id
    ${response_json}=    Evaluate    json.loads($RESPONSE.content)    json
    ${merchantList}=    Get Value From Json    ${response_json}    $.data.merchantId
    Set Test Variable    ${MERCHANT_ID}    ${merchantList}[0]
The response status code should be ${status}
    Should Be Equal As Numbers    ${RESPONSE.status_code}    ${status}

The response should contain "${text}"
    Should Contain    ${RESPONSE.content}    ${text}

The response should contain the merchant details
    ${response_json}=    Evaluate    json.loads($RESPONSE.content)    json
    Dictionary Should Contain Key    ${response_json["data"]}    merchantId
    ${actualBaseCurrency}=    Get Value From Json    ${response_json}    $.data.baseCurrency
    ${actualInvoicePrefix}=    Get Value From Json    ${response_json}    $.data.invoicePrefix
    ${actualDueAfter}=    Get Value From Json    ${response_json}    $.data.dueAfter
    ${actualNextInvoiceNumber}=    Get Value From Json    ${response_json}    $.data.nextInvoiceNumber
    ${actualMcc}=    Get Value From Json    ${response_json}    $.data.mcc
    ${actualMccName}=    Get Value From Json    ${response_json}    $.data.mccName
    ${actualLoyaltyEligible}=    Get Value From Json    ${response_json}    $.data.loyaltyEligible
    ${actualLoyaltyEligible}=    Convert To String    ${actualLoyaltyEligible}[0]

    Should Be Equal    ${actualBaseCurrency}[0]    ${baseCurrency}
    Should Be Equal    ${actualInvoicePrefix}[0]    ${invoicePrefix}
    Should Be Equal    ${actualDueAfter}[0]    ${dueAfter}
    Should Be Equal    ${actualNextInvoiceNumber}[0]    ${nextInvoiceNumber}
    Should Be Equal    ${actualMcc}[0]    ${mcc}
    Should Be Equal    ${actualMccName}[0]    ${mccName}
    Should Be Equal    ${actualLoyaltyEligible}    ${loyaltyEligible}

I send a GET request to retrieve all merchants expected status ${status} using ${paramKey}: ${paramValue}
    ${params}=    Create Dictionary    ${paramKey}=${paramValue}
    ${HEADERS}=    Create Dictionary    Content-Type=application/json    Authorization=${ACCESS_TOKEN}
    Create Session    host    ${host}
    ${response}=    GET On Session    host    ${merchantsPath}    headers=${HEADERS}    expected_status=${status}    params=${params}
    Set Test Variable    ${RESPONSE}    ${response}

I have invalid merchant id
    ${MERCHANT_ID}=    Generate Random String
    ${invalidMerchantIdMessage}=    Set Variable    The merchantId (${MERCHANT_ID}) is invalid. The merchantId must be in the format UUID (8aec4498-46c4-495f-b817-2f30dff8420a).
    Set Test Variable    ${MERCHANT_ID}
    Set Test Variable    ${invalidMerchantIdMessage}


The get response should contain the merchant details
    ${response_json}=    Evaluate    json.loads($RESPONSE.content)    json
    Dictionary Should Contain Key    ${response_json["data"]}    merchantId

The response should contain a list of merchants with pagination
    ${response_json}=    Evaluate    json.loads($RESPONSE.content)    json
    Dictionary Should Contain Key    ${response_json}    paging
    Dictionary Should Contain Key    ${response_json["paging"]}    pageNumber
    Dictionary Should Contain Key    ${response_json["paging"]}    pageSize
    Dictionary Should Contain Key    ${response_json["paging"]}    totalRecords


The response should contain merchants with given ${paramKey}: ${paramValue}
    ${response_json}=    Evaluate    json.loads($RESPONSE.content)    json
    ${actualParamValue}=    Get Value From Json    ${response_json}    $.data[0].${paramKey}
    Should Contain    ${actualParamValue}    ${paramValue}