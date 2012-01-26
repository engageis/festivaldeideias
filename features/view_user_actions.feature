Feature: View user actions
  In order to know more about my actions on the website
  As an user
  I want to view options and information about my actions

  Scenario: View user actions as a logged user
    Given 1 idea category exist
    And 3 ideas exist
    And I'm a logged user
    When I visit the ideas index page
    Then I should see user options
    And I should see "Notificações"
    And I should see a list of notifications
    And I should see my profile image
    And I should see my colaborations count
    And I should see "Meu perfil"
    And I should see "Sair"
    And I should see my ideas count

  Scenario: View user actions as a visitor
    Given 1 idea category exist
    And 3 ideas exist
    When I visit the ideas index page
    Then I should see user options
    And I should see "Criar uma conta"
    And I should see "Fazer login"
