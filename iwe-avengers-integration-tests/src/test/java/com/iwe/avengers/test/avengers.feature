Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://lblflgf89j.execute-api.us-east-1.amazonaws.com/dev/'

Scenario: Get Avenger by Id

Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
When method get
Then status 200
And match response == {id: '#string', name: '#string', secretIdentity: '#string'}

Scenario: create a new avenger

Given path 'avengers'
And request {name: 'Capitain America', secretIdentity: 'Steve Rogers'}
When method post
Then status 201

Scenario: Creates a new avenger without the required data
Given path 'avengers'
And request {name: 'Capitao America'} 
When method post
Then status 400

Scenario: Deleta um avenger existente
Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
When method delete
Then status 204

Scenario: Atualiza um id com sucesso
Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
And request {name: 'Homem Aranha', secretIdentity: 'Peter Parker'}
When method put
Then status 200
And match response == {id: '#string', name: '#string', secretIdentity: '#string'}

Scenario: Erro ao tentar atualizar recurso, por nao informar campos obrigatorios
Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
And request {name: 'Homem Aranha'}
When method put
Then status 400

 





 