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
And header Authorization = 'Bearer ' + token
When method get
Then status 404
And header Authorization = 'Bearer ' + token


Scenario: create a new avenger

Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name: 'Homem Aranha', secretIdentity: 'Peter Parker'}
When method post
Then status 201
And match response == {id: '#string', name: 'Homem Aranha', secretIdentity: 'Peter Parker'}

* def savedAvenger = response

Given path 'avengers', savedAvenger.id
And header Authorization = 'Bearer ' + token
When method get
Then status 200
And match $ == savedAvenger
And header Authorization = 'Bearer ' + token

Scenario: Creates a new avenger without the required data
Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name: 'Capitao America'} 
When method post
Then status 400

Scenario: Deleta um avenger existente

#Create a new Avenger
Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name: 'Hulk', secretIdentity: 'Bruce Banner'}
When method post
Then status 201

* def avengerToDelete = response

#Delete the Avenger
Given path 'avengers', avengerToDelete.id
And header Authorization = 'Bearer ' + token
When method delete
Then status 204

#Search deleted Avenger
Given path 'avengers', avengerToDelete.id
And header Authorization = 'Bearer ' + token
When method get
Then status 404


Scenario: Erro ao deletar avenger, por nao encontrar id
Given path 'avengers', 'xxxx'
And header Authorization = 'Bearer ' + token
When method delete
Then status 404

Scenario: Should return non-authorized access

Given path 'avengers', 'anyid'
And header Authorization = 'Bearer ' + token + 'a'
When method get
Then status 403


Scenario: Atualiza um id com sucesso
#Create a new Avenger
Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name: 'Captain', secretIdentity: 'Steve'}
When method post
Then status 201

* def updatedAvengerDeleted = response

#Updates Avenger
Given path 'avengers', updatedAvengerDeleted.id
And header Authorization = 'Bearer ' + token
And request {name: 'Captain America', secretIdentity: 'Steve Rogers'}
When method put
Then status 200
And match $.id == updatedAvengerDeleted.id
And match $.name == 'Captain America'
And match $.secretIdentity == 'Steve Rogers'

Given path 'avengers', updatedAvengerDeleted.id
And header Authorization = 'Bearer ' + token
When method get
Then status 200
And match $.id ==  updatedAvengerDeleted.id
And match $.name == 'Captain America'
And match $.secretIdentity == 'Steve Rogers'


Scenario: Erro ao tentar atualizar recurso, por nao informar campos obrigatorios
Given path 'avengers', 'aaaa-bbbb-cccc-dddd'
And header Authorization = 'Bearer ' + token
And request {name: 'Homem Aranha'}
When method put
Then status 400

Scenario: Erro ao tentar atualizar recurso, por nao encontrar id
Given path 'avengers', 'xxxx'
And header Authorization = 'Bearer ' + token
And request {name: 'Homem Aranha', secretIdentity: 'Peter Parker'}
When method put
Then status 404




 





 