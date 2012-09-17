Feature: View the timeline
  In order to have a glimpse about what's going on
  As a visitor
  I want to see the latest activities

  Scenario: An user visits the timeline
    Given there is an user called "Paul McCartney", with email "paul@mccartney.com"
    And there is an idea called "Eleanor Rigby" by "Paul McCartney"
    And there is an idea called "A Day in the Life" by "John Lennon"
    And "Paul McCartney" collaborated on the idea "A Day in the Life"
    When I visit the timeline page
    Then I should see the title as "Atividade recente"
    And I should see "Paul McCartney iniciou uma nova ideia chamada Eleanor Rigby"
    And I should see "John Lennon iniciou uma nova ideia chamada A Day in the Life"
    And I should see "John Lennon aceitou a colaboração de Paul McCartney na ideia A Day in the Life"
    