Feature: Articles

    Background:
        Given url apiUrl
        * def articleRequestBody = read("classpath:conduitApp/json/newArticleRequest.json")
        * def dataGenerator = Java.type("helpers.DataGenerator")
        * def generateArticleValues = dataGenerator.getRandomArticleValues()
        * set articleRequestBody.article.title = generateArticleValues.title
        * set articleRequestBody.article.description = generateArticleValues.description
        * set articleRequestBody.article.body = generateArticleValues.body

    Scenario: Create new article
        Given path '/articles'
        Given request articleRequestBody
        When method POST
        Then status 200
        And match response.article.title == articleRequestBody.article.title
        * def slug = response.article.slug

    Scenario: Delete article
        Given path '/articles'
        Given request articleRequestBody
        When method POST
        Then status 200
        And match response.article.title == articleRequestBody.article.title
        * def slug = response.article.slug

        Given params {limit: 10, offset: 0}
        Given path '/articles' 
        When method Get
        Then status 200
        And match response.articles[0].title == articleRequestBody.article.title

        Given path '/articles/' + slug
        When method Delete
        Then status 200

        Given params {limit: 10, offset: 0}
        Given path '/articles' 
        When method Get
        Then status 200
        And match response.articles[0].title != articleRequestBody.article.title