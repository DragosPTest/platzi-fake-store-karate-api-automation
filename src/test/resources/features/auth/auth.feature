@regression
Feature: Validate user logins, retrieving users profiles and access token refresh

  Background: Setup the base URL
    Given url 'https://api.escuelajs.co'

  @login @auth @positive @smoke
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

  @login @auth @negative
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

  @login @auth @negative
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


  @login @token @auth @positive
  Scenario: GET https://api.escuelajs.co/api/v1/auth/profile retrieves user profile
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
    * def authUser = read('classpath:/requests/user-login.json').authUser
    * set authUser.email = userInfo.email
    * set authUser.password = userInfo.password
    Given path '/api/v1/auth/login'
    And request authUser
    When method post
    Then status 201
    * def accessToken = response.access_token
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

  @login @auth @token @negative
  Scenario Outline: GET https://api.escuelajs.co/api/v1/auth/profile returns 401Unauthorized for invalid and missing tokens
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
    * def authUser = read('classpath:/requests/user-login.json').authUser
    * set authUser.email = userInfo.email
    * set authUser.password = userInfo.password
    Given path '/api/v1/auth/login'
    And request authUser
    When method post
    Then status 201
    * def accessToken = response.access_token + 'invalid'
    Given path '/api/v1/auth/profile'
    And header Authorization = <Token>
    When method get
    Then status <status>
    And match response == <message>
    Examples:
      | Token                   | status | message                                     |
      | 'Bearer ' + accessToken | 401    | {"message":"Unauthorized","statusCode":401} |
      | null                    | 401    | {"message":"Unauthorized","statusCode":401} |

  @auth @token @positive @smoke
  Scenario: POST https://api.escuelajs.co/api/v1/auth/refresh-token will successfully refresh a token
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
    * def loginTokens = call read('classpath:utils/login-user-helper.feature')
    * def refreshTokenRequest = read('classpath:requests/refresh-token.json')
    * set refreshTokenRequest.refreshToken = loginTokens.refreshToken
    Given path '/api/v1/auth/refresh-token'
    And request refreshTokenRequest
    When method post
    Then status 201
    And match response.refresh_token != refreshTokenRequest

  @auth @token @negative
  Scenario: POST /auth/refresh-token returns 401 for invalid tokens
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
    * def loginTokens = call read('classpath:utils/login-user-helper.feature')
    * def refreshTokenRequest = read('classpath:requests/refresh-token.json')
    * def validRefreshToken = loginTokens.refresh_token
    * set refreshTokenRequest.refreshToken = validRefreshToken + 'Invalid'
    Given path '/api/v1/auth/refresh-token'
    And request refreshTokenRequest
    When method post
    Then status 401
    And match response == {message: 'Invalid', error: 'Unauthorized', statusCode: 401}

  @auth @token @negative
  Scenario: POST /auth/refresh-token returns 400BadRequest for empty refresh tokens
    * def userInfo = call read('classpath:utils/create-user-helper.feature')
    * def loginTokens = call read('classpath:utils/login-user-helper.feature')
    * def refreshTokenRequest = read('classpath:requests/refresh-token.json')
    * def validRefreshToken = loginTokens.refresh_token
    * set refreshTokenRequest.refreshToken = ""
    Given path '/api/v1/auth/refresh-token'
    And request refreshTokenRequest
    * print "Request Body ", refreshTokenRequest
    When method post
    Then status 400
    And match response == { message: ['refreshToken should not be empty'], error: 'Bad Request', statusCode: 400 }
    * print response



















