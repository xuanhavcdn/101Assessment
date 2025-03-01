
*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Resource    ../resources/merchant_service_automated_test.robot


*** Variables ***

*** Test Cases ***
Test case 01: Retrieve Existing Merchant Successfully
    [Documentation]    Verify that retrieving an existing merchant returns a 200 response with correct details.
    Given I have existing valid merchant id with expected status 200
    And I use an valid access token
    When I send a GET request to retrieve merchant details with expected status 200
    Then the response status code should be 200
    And The get response should contain the merchant details

Test case 02: Get Merchant Details With Invalid Access Token
    [Documentation]    Verify that requesting merchant details with an invalid access token returns 401 Unauthorized.
    Given I have existing valid merchant id with expected status 200
    And I use an invalid access token
    When I send a GET request to retrieve merchant details with expected status 401
    Then the response status code should be 401
    And The response should contain "Unauthorized"

Test case 03: Get Merchant Details With Invalid MerchantId
    [Documentation]    Verify that requesting merchant details with an invalid merchantId returns 400 Bad Request.
    Given I have invalid merchant id
    And I use an valid access token
    When I send a GET request to retrieve merchant details with expected status 400
    Then the response status code should be 400
    And The response should contain "${invalidMerchantIdMessage}"