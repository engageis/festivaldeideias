Feature: View an idea
  In order to discover an idea's content
  As a visitor
  I want to view an idea

  Scenario: View an idea
    Given there is an idea called "My idea lol" that belongs to "Mobilidade Urbana"
    When I visit the "My idea lol" idea page
    Then I should see the title as "My idea lol · Festival de Ideias 2013"
