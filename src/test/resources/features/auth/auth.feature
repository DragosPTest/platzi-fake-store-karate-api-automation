@regression
Feature: Validate user logins, retrieving users profiles and access token refresh

  Background: Setup the base URL
    Given url 'https://api.escuelajs.co'

  @Test
  Scenario: POST https://api.escuelajs.co/api/v1/auth/login successfully login the user and returns access and refresh tokens
    * def userCreds = call read('classpath:utils/create-user.feature')
    * def authUser = read('classpath:/requests/user-login.json').authUser
    * def userEmail = userCreds.email
    * def userPassword = userCreds.password
    * authUser.email = userCreds.email
    * authUser.password = userCreds.password
    Given path '/api/v1/auth/login'
    And request authUser
    When method post
    Then status 201
    And match response.access_token == '#string'
    And match response.refresh_token == '#string'
