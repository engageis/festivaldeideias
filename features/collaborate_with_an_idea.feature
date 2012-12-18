Feature: Collaborate with an idea
  In order to improve the quality and the idea
  As an user
  I want to collaborate with an idea

  @omniauth_test @javascript
  Scenario: I want to collaborate 
    Given there is an idea called "Carona me" that belongs to "Mobilidade Urbana"
    And I'm a logged user  
    And I click "Carona me"
    And I click "Colabore com a ideia"
    And I fill the form
    When I submit the form
    Then I should see "Sua colaboração ainda não está visível, o moderador da ideia precisa aceitá-la para que ela seja incorporada."
  
  @omniauth_test @javascript 
  Scenario: My collaboration was accepted
    Given there is an idea called "Carona me" by "Hitchhiker"
    And I'm a logged user  
    And I made a collaboration called "Carona.me updated title" in the idea "Carona me" and it was accepted
    And I am in "the homepage"
    When I click in the notifications bar
    Then I should see "Hitchhiker aceitou a sua colaboração na ideia Carona me"

  @omniauth_test @javascript 
  Scenario: My collaboration was rejected :(
    Given there is an idea called "Carona me" by "Hitchhiker"
    And I'm a logged user  
    And I made a collaboration called "Carona.me updated title" in the idea "Carona me" and it was rejected
    And I am in "the homepage"
    And I click in the notifications bar
    Then I should see "Hitchhiker recusou a sua colaboração na ideia Carona me. Clique aqui se deseja criar uma nova ideia a partir desta colaboração"
    When I click "Clique aqui"
    Then I should see "Você está prestes a ramificar uma ideia"
    When I click "Ramificar"
    Then I should see "Ideia ramificada com sucesso!" 
