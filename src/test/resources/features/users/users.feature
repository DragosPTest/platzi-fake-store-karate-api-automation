Feature: Validate users creation, users updates, fetching users and email availability of users


  Background: Setup the base URL
    Given url 'https://api.escuelajs.co'
    * def userName = 'Test Name'
    * def userEmail = 'testemail@example.com'
    * def password = 'testpass123'
    * def avatar = 'https://picsum.photos/800'

  Scenario: GETapi/v1/users returns all users when a limit parameter is not specified
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


  Scenario Outline: GET /api/v1/users returns only the number of users specified by the limit parameter
    And path '/api/v1/users'
    And param limit = '<limit>'
    When method get
    Then status <status>
    And assert response.length == <responseLength>

    Examples:
      | limit | responseLength | status |
      | 1     | 1              | 200    |
      | 2     | 2              | 200    |
      | as123 | null           | 400    |

  Scenario: POST /api/v1/users/ will successfully create a user
    * def user = read('classpath:/requests/create-user.json')
    * set user.name = userName
    * set user.email = userEmail
    * set user.password = password
    And path '/api/v1/users/'
    And request user
    When method post
    And print response
    Then status 201
    And match response.id != null
    And match response.name == userName
    And match response.email == userEmail
    And match response.avatar == avatar
    And match response.creationAt == '#string'
    And match response.updatedAt == '#string'






