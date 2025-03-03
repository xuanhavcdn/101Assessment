
*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Resource    ../resources/merchant_service_automated_test.robot
Variables    ../variables/url.py

*** Variables ***
${mmcNameParams}    SHOPPING & RETAIL
${mmcKey}    mccName
${pageNumberKey}    pageNumber
${pageNumberValue}    test123

*** Test Cases ***
# Test case 01: Retrieve All Merchants Without Query Parameters
#     [Documentation]    Verify retrieving all merchants without filters returns a 200 response with pagination metadata.
#     Given I use an valid access token
#     When I send a GET request to retrieve all merchants expected status 200 using '': ''
#     Then the response status code should be 200
#     And The response should contain a list of merchants with pagination

# Test case 02: Retrieve All Merchants With Invalid Access Token
#     [Documentation]    Verify that requesting merchants with an invalid access token returns 401 Unauthorized.
#     Given I use an invalid access token
#     When I send a GET request to retrieve all merchants expected status 401 using '': ''
#     Then the response status code should be 401
#     And The response should contain "Unauthorized"

# Test case 03: Retrieve All Merchants Using Valid mccName
#     [Documentation]    Verify filtering merchants by valid mccName returns merchants with that category.
#     Given I use an valid access token
#     When I send a GET request to retrieve all merchants expected status 200 using ${mmcKey}: ${mmcNameParams}
#     Then the response status code should be 200
#     And The response should contain merchants with given ${mmcKey}: ${mmcNameParams}

# Test case 04: Retrieve All Merchants Using Invalid pageNumber
#     [Documentation]    Verify that requesting merchants with an invalid pageNumber returns 400 Bad Request.
#     Given I use an valid access token
#     When I send a GET request to retrieve all merchants expected status 400 using ${pageNumberKey}: ${pageNumberValue}
#     Then the response status code should be 400
#     And The response should contain "${incorrectPageTypeMessage}"

Test case 01: Retrieve All Merchants Without Query Parameters
    [Documentation]    Verify retrieving all merchants without filters returns a 200 response with pagination metadata.
    Given I use an valid access token
    When I send a GET request of Retrieve All Merchants with ${merchantsPath}, params '' and expected status 200
    Then the response status code should be 200
    And The response should contain a list of merchants with pagination
