require 'acceptance/acceptance_helper'

feature 'Admin interface', %q{
  In order to manage ramify contentes and sites
  As a root user
  I want to see admin options for root admin
} do

  scenario 'I visit admin interface and I should see links for content administration' do
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

feature 'Admin interface for site admin', %q{
  In order to manage one site
  As a site administrator
  I want to see admin options for site admin
} do
  
  scenario 'I visit admin interface and I should see links for specific site administration' do
    site = current_site
    visit fake_login("site=#{site.id}")
    find("a.user").click
    page.should have_link('Painel administrativo')
    visit admin_dashboard_path
    # page.should have_link('Dashboard')
    # page.should have_link('Categories')
    # page.should have_link('Comments')
    # page.should have_link('Links')
    # page.should have_link('Templates')
    # page.should have_link('Users')
    # page.should_not have_link('Configurations')
    # page.should have_link('Ideas')
    # page.should_not have_link('Oauth Providers')
    # page.should_not have_link('Sites')
  end

end
