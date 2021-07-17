Feature: Test for the home page conduit app

    Background: Define URL
        Given url apiUrl

    Scenario: Get all tags
        Given path '/tags' 
        When method Get
        Then status 200
        And match response.tags contains ['dragons', 'SIDA']
        And match response.tags !contains ['aeroplano']
        And match response.tags contains any ['HITLER', 'SIDA', 'butt']
        #And match response.tags contains only ['HITLER', 'SIDA', 'butt']
        And match response.tags == '#array'

    Scenario: Get 10 articles from the page
        * def timeValidator = read('classpath:helpers/timeValidator.js')

        Given params {limit: 10, offset: 0}
        Given path '/articles' 
        When method Get
        Then status 200
        And match response.articlesCount == 500
        And match response.articlesCount != 100
        And match response.articles == '#[10]' 
        And match response == {"articles": "#array", "articlesCount": 500}
        And match response.articles[0].createdAt contains '2021'
        And match response.articles[*].favoritesCount contains 1
        And match response.articles[*].tagList contains []
        And match each response.articles[*].author.following == false
        And match each response..following == "#boolean"
        And match each response..favoritesCount == "#number"
        And match each response..bio == "##string"
        And match each response.articles ==
        """
            {
                "title": "#string",
                "slug": "#string",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "tagList": "#array",
                "description": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                },
                "favorited": "#boolean",
                "favoritesCount": "#number"
            }
        """