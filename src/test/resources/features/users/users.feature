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
    * def createUser = read('classpath:/requests/create-user.json')
    * def user = createUser.createUser
    * set user.name = userName
    * set user.email = userEmail
    * set user.password = password
    * set user.avatar = avatar
    And print "request body ", user
    And path '/api/v1/users/'
    And request user
    When method post
    Then status 201
    And match response.id != null
    And match response.name == userName
    And match response.email == userEmail
    And match response.avatar == avatar
    And match response.role == 'customer'
    And match response.creationAt == '#string'
    And match response.updatedAt == '#string'


  Scenario Outline: Scenario: POST /api/v1/users fails with 400 Bad Request when required fields are missing <expectedResponse>
    * def createUser = read('classpath:/requests/create-user.json')
    * def user = createUser.createUser
    * set user.name = "<name>"
    * set user.email = "<email>"
    * set user.password = "<password>"
    * set user.avatar = "<avatar>"
    And path '/api/v1/users/'
    And request user
    When method post
    Then status <status>
    And match response.message contains any <expectedResponse>

    Examples:
      | name       | email                | password | avatar                    | status | expectedResponse
      |            | test123@email.com    | pass1    | https://picsum.photos/800 | 400    | ["name should not be empty"]                                                                                                              |
      | test1234   |                      | pass2    | https://picsum.photos/800 | 400    | ["email must be an email","email should not be empty"]                                                                                    |
      | test1234   | test                 | pass2    | https://picsum.photos/800 | 400    | ["email must be an email"]                                                                                                                |
      | test12345  | test12345@email.com  |          | https://picsum.photos/800 | 400    | ["password must be longer than or equal to 4 characters","password should not be empty","password must contain only letters and numbers"] |
      | test12345  | test12345@email.com  | 123      | https://picsum.photos/800 | 400    | ["password must be longer than or equal to 4 characters"]                                                                                 |
      | test12345  | test12345@email.com  | ####     | https://picsum.photos/800 | 400    | ["password must contain only letters and numbers"]                                                                                        |
      | test123456 | test123456@email.com | pass3    |                           | 400    | ["avatar should not be empty","avatar must be a URL address"]                                                                             |
      | test123456 | test123456@email.com | pass3    | test                      | 400    | ["avatar must be a URL address"]                                                                                                          |


  Scenario: POST/api/v1/users/is-available returns unavailable users when passing an existing email
    * def userAvailability = read('classpath:/requests/create-user.json')
    * def user = userAvailability.userAvailability
    * set user.email = userEmail
    And path '/api/v1/users/is-available'
    And request user
    When method post
    Then status 201
    And match response.isAvailable == false



  Scenario: POST/api/v1/users/is-available returns 400 Bad Request when no email is passed
    * def userAvailability = read('classpath:/requests/create-user.json')
    * def user = userAvailability.userAvailability
    * set user.email = null
    And path '/api/v1/users/is-available'
    And request user
    When method post
    Then status 400
    And match response.message contains "email must be an email"






