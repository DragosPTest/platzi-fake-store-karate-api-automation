Feature: Create a user

  Background:
    Given url 'https://api.escuelajs.co'

  Scenario: Create and set user credentials
    * def createUser = read('classpath:/requests/create-user.json').createUser
    Given path '/api/v1/users/'
    And request createUser
    When method post
    Then status 201
    * def email = response.email
    * def password = response.password
    * karate.set('userCreds', { email: email, password: password })
