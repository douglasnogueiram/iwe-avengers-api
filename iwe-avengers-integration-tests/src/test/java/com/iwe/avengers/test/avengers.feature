Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://lblflgf89j.execute-api.us-east-1.amazonaws.com/dev/'

* def getToken =
"""
function() {
 var TokenGenerator = Java.type('com.iwe.avengers.test.authorization.TokenGenerator');
 var sg = new TokenGenerator();
 return sg.getToken();
}
"""
* def token = call getToken


Scenario: Deve retornar acesso não autorizado
Given path 'avengers', 'anyid'
When method get
Then status 401



Scenario: Avenger not found

Given path 'avengers', 'avenger-not-found'
When method get
Then status 404
And header Authorization = 'Bearer ' + token


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
And header Authorization = 'Bearer ' + token

Scenario: Creates a new avenger without the required data
Given path 'avengers'
And request {name: 'Capitao America'} 
When method post
Then status 400

Scenario: Deleta um avenger existente
Given path 'avengers'
And request {name: 'Teste deleta Avenger', secretIdentity: 'Identidade secreta teste deleta'}
When method post
Then status 201

* def savedAvengerDeleted = response

Given path 'avengers', savedAvengerDeleted.id
When method delete
Then status 204

Given path 'avengers', savedAvengerDeleted.id
When method get
Then status 404
And header Authorization = 'Bearer ' + token




Scenario: Erro ao deletar avenger, por nao encontrar id
Given path 'avengers', 'xxxx'
When method delete
Then status 404


Scenario: Atualiza um id com sucesso
Given path 'avengers'
And request {name: 'Teste antes atualizar nome', secretIdentity: 'Identidade secreta antes atualizar'}
When method post
Then status 201


* def updatedAvengerDeleted = response

Given path 'avengers', updatedAvengerDeleted.id
And request {name: 'Teste depois atualizar nome x', secretIdentity: 'Identidade secreta depois atualizar x'}
When method put
Then status 200
And match $.id == updatedAvengerDeleted.id
And match $.name == 'Teste depois atualizar nome'
And match $.secretIdentity == 'Identidade secreta depois atualizar'

Given path 'avengers', updatedAvengerDeleted.id
When method get
Then status 200


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




 





 