Feature: View my admin dashboard
  In order to manage and keep things organized
  As an admin user
  I want to view my dashboard options

  Scenario: View dashboard options
    Given I'm an admin user
    When I go to the admin index page
    And I fill the admin login form with my information
    Then I should be in the "admin_dashboard_path"
    And I should see "Painel Administrativo"
    And I should see "Categorias"
    And I should see "Sair"
