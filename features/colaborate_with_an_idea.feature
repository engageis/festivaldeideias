Feature: Colaborate with an idea
  In order to improve the quality and the idea
  As an user
  I want to colaborate with an idea

  @omniauth_test @javascript
  Scenario: I want to colaborate 
    Given there is an idea called "Carona me" that belongs to "Mobilidade Urbana"
    And I'm a logged user  
    And I click "Carona me"
    And I click "Colabore na ideia"
    And I fill the form
    When I submit the form
    Then I should see "Sua colaboração ainda não está visível, o moderador da ideia precisa aceitá-la para que ela seja incorporada."
  
  @omniauth_test @javascript 
  Scenario: My colaboration was accepted
    Given there is an idea called "Carona me" that belongs to "Mobilidade Urbana"
    And I'm a logged user  
    And I made a colaboration called "Carona.me updated title" in the idea "Carona me" and it was accepted
    And I am in "the homepage"
    When I click in the notifications bar
    Then I should see "A sua colaboração para a ideia Carona me foi aceita!"

  @omniauth_test @javascript 
  Scenario: My colaboration was rejected :(
    Given there is an idea called "Carona me" that belongs to "Mobilidade Urbana"
    And I'm a logged user  
    And I made a colaboration called "Carona.me updated title" in the idea "Carona me" and it was rejected
    And I am in "the homepage"
    And I click in the notifications bar
    When I click "A sua colaboração para a ideia Carona me foi recusada. Clique aqui se deseja criar uma nova ideia a partir desta colaboração"
    Then I should see "Você está prestes a ramificar uma ideia"
    When I click "Ramificar"
    Then I should see "Ideia ramificada com sucesso!" 
