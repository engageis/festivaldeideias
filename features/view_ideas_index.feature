Feature: View a selection of ideas
  In order to have a glimpse over the ideas
  As a visitor
  I want to view a selection of ideas

  Scenario: View a selection of ideas
    Given 3 category exist
    And 3 ideas exist
    When I visit the ideas index page
    Then I should see a list of categories
    And I should see a list with ideas

  Scenario: View an institutional video
    Given 3 visible institutional videos exist
    When I visit the ideas index page
    Then I should see the latest video

  Scenario: No institutional videos registered
    Given no visible institutional video exists
    When I visit the ideas index page
    Then I should see the default video
