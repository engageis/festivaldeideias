Feature: Create a category
  In order to manage ideas and how user interact with them
  As an admin user
  I want to create a category

  Scenario: View categories already created
    Given I'm an admin user
    When I go to the admin index page
    And I fill the admin login form with my information
    Then I should be in the "admin_dashboard_path"
    And I click the link "Categorias"
    Then I should be in the "admin_idea_categories_path"

  Scenario: Create a category
    Given I'm an admin user
    When I go to the admin index page
    And I fill the admin login form with my information
    Then I should be in the "admin_dashboard_path"
    And I click the link "Categorias"
    Then I should be in the "admin_idea_categories_path"
    And I click the link "Novo(a) Categoria"
    Then I should be in the "new_admin_idea_category_path"
    And I fill the form with my category data
