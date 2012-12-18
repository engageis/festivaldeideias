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
    And I fill the collaboration box
    When I submit the form
    Then I should see "Muito obrigado por sua colaboração!"
