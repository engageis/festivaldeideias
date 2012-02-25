Feature: View an Idea
  In order to know more about an idea
  as a visitor
  I want to view an idea

  Scenario: View an idea
    Given 1 ideas exist
    When I visit the ideas index page
    Then I click the idea title
    And I should see the idea's title
    And I should see the idea's description
    And I should see "Colaborar com esta ideia"
