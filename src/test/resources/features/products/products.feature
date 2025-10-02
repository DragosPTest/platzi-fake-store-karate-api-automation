@regression
Feature: Validate product listing, retrieval by ID and slug, and pagination

  Background: Base URL setup
    Given url 'https://api.escuelajs.co'

  @get @products @positive @smoke
  Scenario: GET https://api.escuelajs.co/api/v1/products returns a list of products
    * def productSchema = { id: '#number', title: '#string', slug: '#string', price: '#number', description: '#string', category: { id: '#number', name: '#string', slug: '#string', image: '#string', creationAt: '#string', updatedAt: '#string' }, images: '#[] #string', creationAt: '#string', updatedAt: '#string' }
    Given path '/api/v1/products'
    When method get
    Then status 200
    And match response[0] == productSchema

  @Test
  Scenario: GET https://api.escuelajs.co/api/v1/products/ returns  asingle product when an id is passed as a path param
    * def id = 7
    * def productSchema = { id: '#(id)', title: '#string', slug: '#string', price: '#number', description: '#string', category: { id: '#number', name: '#string', slug: '#string', image: '#string', creationAt: '#string', updatedAt: '#string' }, images: '#[] #string', creationAt: '#string', updatedAt: '#string' }
    Given path 'api', 'v1', 'products', id
    When method get
    Then status 200
    And match response == productSchema





