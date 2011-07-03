require 'acceptance/acceptance_helper'

feature 'Admin interface', %q{
  In order to manage ramify contentes and sites
  As a root user
  I want to see admin options for root admin
} do

  scenario 'I visit admin interface I should see links for content administration' do
    visit fake_login('root_admin=true')
    page.should have_link('Painel administrativo')

    find("a.user").click
    click_link('Painel administrativo')
    visit admin_dashboard_path
    page.should have_link('Dashboard')
    page.should have_link('Categories')
    page.should have_link('Comments')
    page.should have_link('Links')
    page.should have_link('Templates')
    page.should have_link('Users')
    page.should have_link('Configurations')
    page.should have_link('Ideas')
    page.should have_link('Oauth Providers')
    page.should have_link('Sites')
  end

end
