@regression
Feature: Validate user logins, retrieving users profiles and access token refresh

  Background: Setup the base URL
    Given url 'https://api.escuelajs.co'

  @Test
  Scenario: POST https://api.escuelajs.co/api/v1/auth/login successfully login the user and returns access and refresh tokens
    * def createUser = read('classpath:/requests/create-user.json')
    * def createUser = createUser.createUser
    * def authUser = read('classpath:/requests/user-login.json')
    * def authUser = authUser.authUser
    # Create the user
    Given path '/api/v1/users/'
    And request createUser
    When method post
    Then status 201
    * def userEmail = response.email
    * def userPassword = response.password
    # Auth the user
    * set authUser.email = userEmail
    * set authUser.password = userPassword
    Given path '/api/v1/auth/login'
    And request authUser
    When method post
    Then status 201
    And match response.access_token == '#string'
    And match response.refresh_token == '#string'
