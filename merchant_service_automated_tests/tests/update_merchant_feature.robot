
*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Resource    ../resources/merchant_service_automated_test.robot
Variables    ../variables/url.py


*** Test Cases ***
Test case 01: Scenario: Update a merchant’s invoicePrefix and loyaltyEligible
    Given I have a valid merchant payload
    And I use a valid access token
    And I send a POST request to "Create New Merchant" with ${merchantsPath}, payload ${PAYLOAD} and expected status 201
    And I have merchant id
    And I set request body with updated invoicePrefix and loyaltyEligible
    When I send a PATCH request to "Update Merchant" with ${merchantsPath}/${MERCHANT_ID}, payload ${PAYLOAD} and expected status 200
    Then The response status code should be 200
    And The response should contain the merchant details

Test case 02: Scenario: Update merchant with an invalid access token
    Given I have a valid merchant payload
    And I use a valid access token
    And I send a POST request to "Create New Merchant" with ${merchantsPath}, payload ${PAYLOAD} and expected status 201
    And I have merchant id
    And I set request body with updated invoicePrefix and loyaltyEligible
    And I use an invalid access token
    When I send a PATCH request to "Update Merchant" with ${merchantsPath}/${MERCHANT_ID}, payload ${PAYLOAD} and expected status 401
    Then The response status code should be 401
    And The response should contain "Unauthorized"

Test case 03: Scenario: Update merchant using an empty baseCurrency value
    Given I have a valid merchant payload
    And I use a valid access token
    And I send a POST request to "Create New Merchant" with ${merchantsPath}, payload ${PAYLOAD} and expected status 201
    And I have merchant id
    And I set request body with an empty baseCurrency
    When I send a PATCH request to "Update Merchant" with ${merchantsPath}/${MERCHANT_ID}, payload ${PAYLOAD} and expected status 400
    Then The response status code should be 400
    And The response should contain "${missingBaseCurrency}"


