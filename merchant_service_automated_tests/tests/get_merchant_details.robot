
*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Resource    ../resources/merchant_service_automated_test.robot
Resource    ../resources/common.robot

*** Test Cases ***
Test case 01: Retrieve Existing Merchant Successfully
    [Documentation]    Verify that retrieving an existing merchant returns a 200 response with correct details.
    Given I have a valid merchant payload
    And I use a valid access token
    And I send a POST request to "Create New Merchant" with ${merchantsPath}, payload ${PAYLOAD} and expected status 201
    And I have merchant id
    When I send a GET request to "Retrieve Merchant" with ${merchantsPath}/${MERCHANT_ID}, params '' and expected status 200
    Then The response status code should be 200
    And The response should contain the merchant details

Test case 02: Get Merchant Details With Invalid Access Token
    [Documentation]    Verify that requesting merchant details with an invalid access token returns 401 Unauthorized.
    Given I have a valid merchant payload
    And I use a valid access token
    And I send a POST request to "Create New Merchant" with ${merchantsPath}, payload ${PAYLOAD} and expected status 201
    And I have merchant id
    And I use an invalid access token
    When I send a GET request to "Retrieve Merchant" with ${merchantsPath}/${MERCHANT_ID}, params '' and expected status 401
    Then The response status code should be 401
    And The response should contain "Unauthorized"

Test case 03: Get Merchant Details With Invalid MerchantId
    [Documentation]    Verify that requesting merchant details with an invalid merchantId returns 400 Bad Request.
    Given I have invalid merchant id
    And I use a valid access token
    When I send a GET request to "Retrieve Merchant" with ${merchantsPath}/${MERCHANT_ID}, params '' and expected status 400
    Then The response status code should be 400
    And The response should contain "${invalidMerchantIdMessage}"