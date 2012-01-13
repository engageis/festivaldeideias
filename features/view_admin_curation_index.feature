Feature: Featured ideas
  In order to show more valuable ideas
  As an admin
  I want to process some ideas

  Scenario: View a list of ideas created by a user
    Given I'm an admin user
    When I go to the admin index page
    And I fill the admin login form with my information
    Then I should be in the "admin_dashboard_path"
    And I click the link "Curação de ideias"
    Then I should be in the "admin_ideas_path"
