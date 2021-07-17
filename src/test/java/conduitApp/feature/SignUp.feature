Feature: Sign Up feature

    Background: Preconditions
        * def dataGenerator = Java.type("helpers.DataGenerator")
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
        Given url apiUrl

    Scenario: Sign up
        Given path '/users'
        And request
            """
            {
            "user": {
            "email": #(randomEmail),
            "password": "12345678",
            "username":#(randomUsername)
            }
            }
            """
        When method POST
        Then status 200
        And match response ==
        """
            {
                "user": {
                    "id": "#number",
                    "email": "#string",
                    "createdAt": "#? timeValidator(_)",
                    "updatedAt": "#? timeValidator(_)",
                    "username": "#string",
                    "bio": "##string",
                    "image": "##string",
                    "token": "#string"
                }
            }
        """
        * def token = response.user.token
        * def id = response.user.id

    Scenario Outline: Sign up error messages
        Given path '/users'
        And request
            """
            {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<username>"
                }
            }
            """
        When method POST
        Then status 422
        And match response == <errorResponse>

        Examples:

            | email                  | password | username                                 | errorResponse                                                                      |
            | #(randomEmail)         | 12345678 | calvario31                               | {"errors":{"username":["has already been taken"]}}                                 |
            | calvario_test@test.com | 12345678 | #(randomUsername)                        | {"errors":{"email":["has already been taken"]}}                                    |
            | #(randomEmail)         | 123456   | #(randomUsername)                        | {"errors":{"password":["is too short (minimum is 8 characters)"]}}                 |
            | #(randomEmail)         | 12345678 | calvario31calvario31calvario31calvario31 | {"errors":{"username":["is too long (maximum is 20 characters)"]}}                 |
            | #(randomEmail)         |          | #(randomUsername)                        | {"errors":{"password":["can't be blank"]}}                                         |
            | #(randomEmail)         | 12345678 |                                          | {"errors":{"username":["can't be blank","is too short (minimum is 1 character)"]}} |

