# coding: utf-8

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
    page.should have_link('Painel administrativo')
    visit admin_dashboard_path
    page.should have_link('Dashboard')
    page.should have_link('Categorias')
    page.should have_link('Links')
    page.should have_link('Templates')
    page.should have_link('Usuários')
    page.should have_link('Configuraçãos')
    page.should have_link('Ideias')
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
    page.should have_link('Dashboard')
    page.should have_link('Usuários')
    page.should have_link('Ideias')
    page.should_not have_link('Configuraçãos')
    page.should_not have_link('Oauth Providers')
    page.should_not have_link('Categorias')
    page.should have_link('Links')
    # TODO, create a section to manage current_site's links, templates and other configurations
    # page.should have_link('Templates')
    # page.should have_link('Sites')
  end

end
