# coding: utf-8

Feature: Create a new page
  In order to add a new institutional page on the site
  As an admin user
  I want to create a new page

  Scenario: View pages already created
    Given I'm an admin user
    When I go to the admin index page
    And I fill the admin login form with my information
    Then I should be in the "admin_dashboard_path"
    And I click the link "Páginas"
    Then I should be in the "admin_pages_path"

  Scenario: Create a page
    Given I'm an admin user
    When I go to the admin index page
    And I fill the admin login form with my information
    Then I should be in the "admin_dashboard_path"
    And I click the link "Páginas"
    Then I should be in the "admin_pages_path"
    And I click the link "Novo(a) Página"
    Then I should be in the "new_admin_page_path"
    And I fill the form with my page data
