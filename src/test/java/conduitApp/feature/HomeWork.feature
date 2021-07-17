Feature: Homework

    Background:
        Given url apiUrl
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        And path '/articles'
        Given params {limit: 10, offset: 0}
        When method GET
        Then status 200

        * def slugId = response.articles[0].slug
        * def initialCount = response.articles[0].favoritesCount
        * def username = username
    Scenario: Favorite articles     
        Given path '/articles/' + slugId + '/favorite'
        When method POST
        Then status 200
        And match response ==
        """
            {
                "article": {
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
            }
        """
        And match response.article.favoritesCount == initialCount + 1

        Given path '/articles'
        Given params {favorited: "#(username)",limit: 10, offset: 0}
        When method GET
        Then status 200
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
        And match response.articles[*].slug contains slugId

        Given path '/articles/' + slugId + '/favorite'
        When method DELETE
        Then status 200
        And match response.article.favoritesCount == initialCount
@debug
    Scenario: Comment articles
        * def newComment = read("classpath:conduitApp/json/newComment.json")
        * def dataGenerator = Java.type("helpers.DataGenerator")
        * def generateComment = dataGenerator.getRandomComment()
        * set newComment.comment.body = generateComment.comment

        Given path '/articles/' + slugId + '/comments'
        When method GET
        Then status 200
        And match response ==
        """
            {
                "comments": "#array"}
            }
        """
        * def initialNumberComments = response.comments.length
        * print 'initialNumberComments: ' +  initialNumberComments

        Given path '/articles/' + slugId + '/comments'
        Given request newComment
        When method POST
        Then status 200
        And match response.comment ==
        """
            {
                "id": "#number",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "body": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
        """
        * def commentId = response.comment.id

        Given path '/articles/' + slugId + '/comments'
        When method GET
        Then status 200
        And match response ==
        """
            {
                "comments": "#array"}
            }
        """
        * def articlesActualCount = response.comments.length
        And match articlesActualCount == initialNumberComments + 1


        Given path '/articles/' + slugId + '/comments/' + commentId
        When method DELETE
        Then status 200
        And match response == {}
        

        Given path '/articles/' + slugId + '/comments'
        When method GET
        Then status 200
        And match response ==
        """
            {
                "comments": "#array"}
            }
        """
        * def articlesActualCount = response.comments.length
        And match articlesActualCount == initialNumberComments
        




