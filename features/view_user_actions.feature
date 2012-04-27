Feature: View user actions
  In order to know more about my actions on the website
  As an user
  I want to view options and information about my actions
  @omniauth_test
  Scenario: View user actions as a logged user
    Given 1 category exist
    And 3 ideas exist
    And I'm a logged user
    When I visit the ideas index page
    Then I should see user options
    And I should see "Notificações"
    And I should see a list of notifications
    And I should see my profile image
    And I should see "Sair"

  Scenario: View user actions as a visitor
    Given 1 category exist
    And 3 ideas exist
    When I visit the ideas index page
    Then I should see user options
    And I should see "Crie uma conta"
    And I should see "Faça login"
