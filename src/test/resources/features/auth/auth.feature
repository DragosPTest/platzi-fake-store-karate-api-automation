@regression
Feature: Validate user logins, retrieving users profiles and access token refresh

  Background: Setup the base URL
    Given url 'https://api.escuelajs.co'

  @login @positive @smoke
  Scenario: POST https://api.escuelajs.co/api/v1/auth/login successfully login the user and returns access and refresh tokens
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
    * def authUser = read('classpath:/requests/user-login.json').authUser
    * set authUser.email = userInfo.email
    * set authUser.password = userInfo.password
    Given path '/api/v1/auth/login'
    And request authUser
    When method post
    Then status 201
    And match response.access_token == '#string'
    And match response.refresh_token == '#string'

  @login @negative
  Scenario: POST https://api.escuelajs.co/api/v1/auth/login returns 401Unauthorized for wrong password
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
    * def authUser = read('classpath:/requests/user-login.json').authUser
    * set authUser.email = userInfo.email
    * set authUser.password = 'wrongPass123'
    Given path '/api/v1/auth/login'
    And request authUser
    When method post
    Then status 401
    And match response.message == "Unauthorized"
    And match response.statusCode == 401

  @login @negative
  Scenario: POST https://api.escuelajs.co/api/v1/auth/login returns 401Unauthorized for wrong email
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
    * def authUser = read('classpath:/requests/user-login.json').authUser
    * set authUser.email = 'wrongEmail@email.com'
    * set authUser.password = userInfo.password
    Given path '/api/v1/auth/login'
    And request authUser
    When method post
    Then status 401
    And match response.message == "Unauthorized"
    And match response.statusCode == 401


  @login @token @positive
  Scenario: GET https://api.escuelajs.co/api/v1/auth/profile retrieves user profile
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
  # Authenticate the user and get the token
    * def authUser = read('classpath:/requests/user-login.json').authUser
    * set authUser.email = userInfo.email
    * set authUser.password = userInfo.password
    * print "User Info ", userInfo
    * print "User Auth: ", authUser
    Given path '/api/v1/auth/login'
    And request authUser
    When method post
    Then status 201
    * def accessToken = response.access_token
    * print "Access Token Value: ", accessToken
  # Retrieve user information
    Given path '/api/v1/auth/profile'
    And header Authorization = 'Bearer ' + accessToken
    When method get
    Then status 200
    And match response.id == userInfo.id
    And match response.email == userInfo.email
    And match response.password == userInfo.password
    And match response.name == userInfo.name
    And match response.role == userInfo.role
    And match response.avatar == userInfo.avatar















