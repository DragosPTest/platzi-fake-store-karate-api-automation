Feature: Create a product

  Background: Setup the base URL
    Given url 'https://api.escuelajs.co'

  Scenario: POST https://api.escuelajs.co/api/v1/products/ successfully creates a product
    * def createProduct = read('classpath:/requests/create-product.json').createProduct
    * def uuid = java.util.UUID.randomUUID() + ''
    * set createProduct.title = 'Product_' + uuid
    * set createProduct.description = 'Description_' + uuid

    * path '/api/v1/products/'
    * request createProduct
    * method post
    * status 201







