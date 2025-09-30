@regression
Feature: Validate product listing, retrieval by ID and slug, and pagination

  Background: Base URL setup
    Given url 'https://api.escuelajs.co'

  @get @products @positive @smoke
  Scenario: GET https://api.escuelajs.co/api/v1/products returns a list of products
    And path '/api/v1/products'
    * def productSchema = { id: '#number', title: '#string', slug: '#string', price: '#number', description: '#string', category: { id: '#number', name: '#string', slug: '#string', image: '#string', creationAt: '#string', updatedAt: '#string' }, images: '#[] #string', creationAt: '#string', updatedAt: '#string' }
    When method get
    Then status 200
    And match response[0] == productSchema



