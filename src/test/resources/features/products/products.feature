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
    Given path '/api/v1/products'
    When method get
    Then status 200
    * def responseId =  response[0].id
    * def products = read('classpath:schemas/products-schema.json')
    * def productSchema = products.productsSchema
    * set productSchema.id = responseId
    Given path 'api', 'v1', 'products', responseId
    When method get
    Then status 200
    And match response == productSchema

  @get @products @negative
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

  @get @products @positive @smoke
  Scenario: GET https://api.escuelajs.co/api/v1/products/slug/ returns a single product by slug
    * def products = read('classpath:schemas/products-schema.json')
    * def productSchema = products.productsSchema
    Given path 'api', 'v1', 'products', 'slug', 'classic-black-hooded-sweatshirt'
    When method get
    Then status 200
    And match response == productSchema
    And match response.slug == "classic-black-hooded-sweatshirt"

  @get @products @negative
  Scenario Outline: GET https://api.escuelajs.co/api/v1/products/slug/ returns 400BadRequest for invalid or non-existing product slugs <slug>
    Given path 'api', 'v1', 'products', 'slug', '<slug>'
    When method get
    Then status <status>
    And match response.message contains <expectedMessage>

    Examples:
      | slug | expectedMessage                                  | status |
      |      | "Validation failed (numeric string is expected)" | 400    |
      | asd1 | "Could not find any entity of type"              | 400    |

  @create @products @positive @smoke
  Scenario: POST https://api.escuelajs.co/api/v1/products/ successfully creates a product
    * def createProduct = read('classpath:/requests/create-product.json').createProduct
    * def uuid = java.util.UUID.randomUUID() + ''
    * def products = read('classpath:schemas/products-schema.json')
    * def productSchema = products.productsSchema
    * set createProduct.title = 'Product_' + uuid
    * set createProduct.description = 'Description_' + uuid
    Given path '/api/v1/products/'
    And request createProduct
    When method post
    Then status 201
    And match response == productSchema
    And match response.title == createProduct.title
    And match response.description == createProduct.description
    And match response.price == createProduct.price
    And match response.category.id == createProduct.categoryId
    And match response.images == createProduct.images












