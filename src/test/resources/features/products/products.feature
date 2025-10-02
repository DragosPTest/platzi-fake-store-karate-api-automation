@regression
Feature: Validate product listing, retrieval by ID and slug, and pagination

  Background: Base URL setup
    Given url 'https://api.escuelajs.co'

  @get @products @positive @smoke
  Scenario: GET https://api.escuelajs.co/api/v1/products returns a list of products
    * def productsSchema = read('classpath:schemas/products-schema.json').productsSchema
    Given path '/api/v1/products'
    When method get
    Then status 200
    And match response[0] == productsSchema


  @get @products @positive @smoke
  Scenario: GET https://api.escuelajs.co/api/v1/products/ returns a single product when an 'id' is passed as a path parameter
    * def id = 7
    * def products = read('classpath:schemas/products-schema.json')
    * def productSchema = products.productsSchema
    * set productSchema.id = id
    Given path 'api', 'v1', 'products', id
    When method get
    Then status 200
    And match response == productSchema

  @get @products @negative @smoke
  Scenario Outline: GET https://api.escuelajs.co/api/v1/products/ returns 400BadRequest for invalid or non-existent product IDs <id>
    Given path 'api', 'v1', 'products', '<id>'
    When method get
    Then status <status>
    And match response.message contains <expectedMessage>

    Examples:
      | id     | expectedMessage                                  | status |
      | -1     | "Could not find any entity"                      | 400    |
      | 0      | "Could not find any entity"                      | 400    |
      | a23#   | "Validation failed (numeric string is expected)" | 400    |
      | 999999 | "Could not find any entity"                      | 400    |








