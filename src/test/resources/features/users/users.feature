Feature: Validate users creation, users updates, fetching users and email availability of users


  Background: Setup the base URL
    Given url 'https://api.escuelajs.co'

  Scenario: GETapi/v1/users returns a list of users when a limit header is not specified
    And path '/api/v1/users'
    When method get
    Then status 200
    And match response != null
    And match response[0].id == '#number'
    And match response[0].name == '#string'
    And match response[0].role == '#string'
    And match response[0].avatar == '#string'
    And match response[0].creationAt == '#string'
    And match response[0].updatedAt == '#string'
    And assert response.length > 1


  Scenario: GETapi/v1/users returns a limit of users
    And path '/api/v1/users'
    And params {limit: 1}
    When method get
    And print response
    Then status 200
    And assert response.length <= 1






