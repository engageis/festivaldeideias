Feature: Colaborate with an idea
  In order to improve the quality and the idea
  As an user
  I want to colaborate with an idea

  @omniauth_test @javascript
  Scenario: My colaboration was accepted 
    Given I'm a logged user 
    And There is a category called "Catastrofes"
    And There is a idea called "Carona me" that belongs to "Catastrofes"
    When I visit the root path
    And I click on the link "Carona me"
