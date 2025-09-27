Feature: Validate users creation, users updates, fetching users and email availability of users


  Background: Setup the base URL
    Given url 'https://api.escuelajs.co'

    Scenario: GETapi/v1/users returns a list of users when a limit is not specified
      And path '/api/v1/users'
      When method get
      Then status 200

