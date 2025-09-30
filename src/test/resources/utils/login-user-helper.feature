Feature: Login a user

  Background:
    Given url 'https://api.escuelajs.co'

  Scenario: Login a user - helper
    * def authUser = read('classpath:/requests/user-login.json').authUser
    * set authUser.email = userInfo.email
    * set authUser.password = userInfo.password
    * path '/api/v1/auth/login'
    * request authUser
    * method post
    * status 201
    * def accessToken = response.access_token
    * def refreshToken = response.refresh_token
    * karate.set('loginTokens', {access_token: accessToken, refresh_token: refreshToken})
