Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://lblflgf89j.execute-api.us-east-1.amazonaws.com/dev/'

Scenario: Avenger not found

Given path 'avengers', 'avenger-not-found'
When method get
Then status 404


Scenario: create a new avenger

Given path 'avengers'
And request {name: 'Homem Aranha', secretIdentity: 'Peter Parker'}
When method post
Then status 201
And match response == {id: '#string', name: 'Homem Aranha', secretIdentity: 'Peter Parker'}

* def savedAvenger = response

Given path 'avengers', savedAvenger.id
When method get
Then status 200
And match $ == savedAvenger

Scenario: Creates a new avenger without the required data
Given path 'avengers'
And request {name: 'Capitao America'} 
When method post
Then status 400

Scenario: Deleta um avenger existente
Given path 'avengers', '15ec4b53-e1a9-42e1-8acb-a5eee021e0f8'
When method delete
Then status 204


Scenario: Erro ao deletar avenger, por nao encontrar id
Given path 'avengers', 'xxxx'
When method delete
Then status 404


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

Scenario: Erro ao tentar atualizar recurso, por nao encontrar id
Given path 'avengers', 'xxxx'
And request {name: 'Homem Aranha', secretIdentity: 'Peter Parker'}
When method put
Then status 404




 





 