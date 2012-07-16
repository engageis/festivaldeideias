Feature: View user actions
  In order to know more about my actions on the website
  As an user
  I want to view options and information about my actions
  @omniauth_test
  Scenario: View user actions as a logged user with no ideas or collaborations
    Given I'm a logged user
    When I visit the ideas index page
    Then I should see user options
    And I should see "Notificações"
    And I should see a list of notifications
    And I should see my profile image
    And I should see "0 ideias próprias, 0 colaborações em ideias."
    And I should see "Sair"

  @omniauth_test
  Scenario: View user actions as a logged user with no ideas and 1 collaboration
    Given I'm a logged user
    And there is an idea called "A Day in the Life" by "John Lennon"
    And I collaborated on the idea "A Day in the Life"
    When I visit the ideas index page
    Then I should see user options
    And I should see "Notificações"
    And I should see a list of notifications
    And I should see my profile image
    And I should see "0 ideias próprias, 1 colaboração em ideias."
    And I should see "Sair"

  @omniauth_test
  Scenario: View user actions as a logged user with 1 idea and no collaborations
    Given I'm a logged user
    And I created an idea
    When I visit the ideas index page
    Then I should see user options
    And I should see "Notificações"
    And I should see a list of notifications
    And I should see my profile image
    And I should see "1 ideia própria, 0 colaborações em ideias."
    And I should see "Sair"

  Scenario: View user actions as a visitor
    Given 1 category exist
    And 3 ideas exist
    When I visit the ideas index page
    Then I should see user options
    And I should see "Faça login"
