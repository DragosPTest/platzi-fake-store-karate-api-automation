Feature: Create a user

  Background:
    Given url 'https://api.escuelajs.co'

  Scenario: Create and set user credentials
    * def createUser = read('classpath:/requests/create-user.json').createUser
    * def uuid = java.util.UUID.randomUUID() + ''
    * set createUser.name = 'User_' + uuid
    * set createUser.email = 'user_' + uuid + '@test.com'

    * path '/api/v1/users/'
    * request createUser
    * method post
    * status 201

    * def id = response.id
    * def name = response.name
    * def email = response.email
    * def password = response.password
    * def avatar = response.avatar
    * def role = response.role

    * karate.set('userInfo', { id: id, name: name, email: email, password: password, avatar: avatar, role: role })
