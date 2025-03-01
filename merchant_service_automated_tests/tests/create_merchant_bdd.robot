*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Resource    ../resources/merchant_service_automated_test.robot

*** Variables ***
${missingBaseCurrency}    The baseCurrency length must be between 3 and 3.
*** Test Cases ***
Test case 1: Create a merchant with valid data and a valid access token in the request header
    Given I have a valid merchant payload
    And I use an valid access token
    When I send a POST request to create a merchant with expected status 201
    Then The response status code should be 201
    And The response should contain the merchant details

Test Case 2: Create a merchant with valid data and an invalid access token in the request header.
    Given I have a valid merchant payload
    And I use an invalid access token
    When I send a POST request to create a merchant with expected status 401
    Then The response status code should be 401
    And The response should contain "Unauthorized"

Test Case 3: Create new Merchant using an empty baseCurrency value
    Given I have a merchant payload with missing base currency
    And I use an valid access token
    When I send a POST request to create a merchant with expected status 400
    Then The response status code should be 400
    And The response should contain "${missingBaseCurrency}"
