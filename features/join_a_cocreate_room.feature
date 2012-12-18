Feature: join a cocreate room
  In order to contribute to an idea
  As a collaborator
  I want to join a cocreate room

  @omniauth_test
  Scenario: when I am not logged in
    Given there is an idea
    And I'm in "this idea page"
    When I click "Sala de cocriação"
    Then I should be in "the login page"
    When I click "entre com sua conta do Facebook"
    Then I should be in "the idea's cocreate page"
