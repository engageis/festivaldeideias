Feature: View an user's profile
  In order to know more about an user
  As a visitor
  I want to view an user's profile

  Scenario: An user with no ideias created or collaborations
    Given there is an user called "Paul McCartney", with email "paul@mccartney.com"
    When I visit the "Paul McCartney" user page
    Then I should see the title as "Paul McCartney · Festival de Ideias 2012"
    And I should see "Paul McCartney"
    And I should not see "paul@mccartney.com"
    And I should see a link "Ir para o perfil no Facebook"
    And I should see "Ideias criadas por Paul McCartney"
    And I should see "Paul McCartney não criou nenhuma ideia ainda."
    And I should see "Ideias com as quais Paul McCartney colaborou"
    And I should see "Paul McCartney não colaborou com nenhuma ideia ainda."

  Scenario: An user with 1 ideia created and no collaborations
    Given there is an user called "Paul McCartney", with email "paul@mccartney.com"
    And there is an idea called "Eleanor Rigby" by "Paul McCartney"
    When I visit the "Paul McCartney" user page
    Then I should see the title as "Paul McCartney · Festival de Ideias 2012"
    And I should see "Paul McCartney"
    And I should not see "paul@mccartney.com"
    And I should see a link "Ir para o perfil no Facebook"
    And I should see "Ideias criadas por Paul McCartney"
    And I should not see "Paul McCartney não criou nenhuma ideia ainda."
    And I should see "Eleanor Rigby"
    And I should see "Ideias com as quais Paul McCartney colaborou"
    And I should see "Paul McCartney não colaborou com nenhuma ideia ainda."

  Scenario: An user with 1 ideia created and 1 collaboration
    Given there is an user called "Paul McCartney", with email "paul@mccartney.com"
    And there is an idea called "Eleanor Rigby" by "Paul McCartney"
    And there is an idea called "A Day in the Life" by "John Lennon"
    And "Paul McCartney" collaborated on the idea "A Day in the Life"
    When I visit the "Paul McCartney" user page
    Then I should see the title as "Paul McCartney · Festival de Ideias 2012"
    And I should see "Paul McCartney"
    And I should not see "paul@mccartney.com"
    And I should see a link "Ir para o perfil no Facebook"
    And I should see "Ideias criadas por Paul McCartney"
    And I should not see "Paul McCartney não criou nenhuma ideia ainda."
    And I should see "Eleanor Rigby"
    And I should see "Ideias com as quais Paul McCartney colaborou"
    And I should not see "Paul McCartney não colaborou com nenhuma ideia ainda."
    And I should see "A Day in the Life"
