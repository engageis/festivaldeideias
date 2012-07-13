Feature: 
  In order to find relevant ideas
  As an user
  I want to search ideas by keyword

  @javascript
  Scenario: when no idea is found
    Given I am in "the ideas navigation page"
    When I fill the idea search form with "carona.me"
    Then I should be in "the ideas navigation by keyword page"
    And I should see "Resultado da sua busca por carona.me"
    And I should see "Nenhuma ideia encontrada"
  
  @javascript
  Scenario: When 2 ideas were found
    Given there is an idea called "My idea lol" that belongs to "Mobilidade Urbana"
    And there is an idea called "Idea from other" that belongs to "Mobilidade Urbana"
    And I am in "the ideas navigation page"
    When I fill the idea search form with "idea"
    Then I should be in "the ideas navigation by keyword page"
    And I should see "Resultado da sua busca por idea"
    And I should see "My idea lol"
    And I should see "Idea from other"

  # TODO: make this scenario work. We're getting a weird connection reset
  # @javascript
  # Scenario: When I search for the author's name
  #   Given there is an idea called "My idea lol" by "Paul McCartney"
  #   And I am in "the ideas navigation page"
  #   When I fill the idea search form with "McCartney"
  #   Then I should be in "the ideas navigation by keyword page"
  #   And I should see "Resultado da sua busca por McCartney"
  #   And I should see "My idea lol"
  #   And I should see "Paul McCartney"
