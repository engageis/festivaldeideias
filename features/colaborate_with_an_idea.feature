Feature: Colaborate with an idea
  In order to improve the quality and the idea
  As an user
  I want to colaborate with an idea

  @omniauth_test @javascript
  Scenario: I want to colaborate 
    Given There is a category called "Catastrofes"
    And There is a idea called "Carona me" that belongs to "Catastrofes"
    And I'm a logged user  
    And I click on the link "Carona me"
    When I click on the link "Colabore na ideia"
    And I fill the form
    And I submit the form
    Then I should see "Sua colaboração foi enviada! Sua colaboração ainda não está visível, o moderador da ideia precisa aceitá-la para que ela seja incorporada."
  
  @omniauth_test @javascript 
  Scenario: My colaboration was accepted
    Given There is a category called "Catastrofes"
    And There is a idea called "Carona me" that belongs to "Catastrofes"
    And I'm a logged user  
    And I made a colaboration called "Carona.me updated title" in the idea "Carona me" and it was accepted
    When I visit the root path
    And I click in the notifications bar
    Then I should see "A sua colaboração para a ideia Carona me foi aceita!"

  @omniauth_test @javascript 
  Scenario: My colaboration was rejected :(
    Given There is a category called "Catastrofes"
    And There is a idea called "Carona me" that belongs to "Catastrofes"
    And I'm a logged user  
    And I made a colaboration called "Carona.me updated title" in the idea "Carona me" and it was rejected
    When I visit the root path
    And I click in the notifications bar
    And I click on the link "A sua colaboração para a ideia Carona me foi recusada. Clique aqui se deseja criar uma nova ideia a partir desta colaboração"
    And I should see "Você está prestes a ramificar uma ideia"
    And I click on the link "Ramificar"
    Then I should see "Ideia ramificada com sucesso!" 
