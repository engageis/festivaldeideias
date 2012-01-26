Feature: View links to the pages
  In order to be able to navigate
  as a visitor
  I want to view the links to the pages in the footer

  Scenario: View the links
    Given 3 pages exist
    When I go to the ideas index page
    Then I should see 3 links to pages
