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
