Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://lblflgf89j.execute-api.us-east-1.amazonaws.com/dev/'

Scenario: Get Avenger by Id

Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
When method get
Then status 200


Scenario: create a new avenger

Given path 'avengers'
And request {name: 'Capitain America', secretIdentitiy: 'Steve Rogers'}
When method post
Then status 201
 