# coding: utf-8
require 'acceptance/acceptance_helper'

feature 'Fork', %q{
  In order to fork an idea
  As a user
  I want to access an idea page and fork it
} do
  
  scenario "search an idea and fork it" do
    idea = Factory.build(:idea, :site => current_site)
    idea.save
    fake_login
    idea.versions.size.should == 0
    find(".idea_wrapper h1 a").click
    click_link("Melhorar esta ideia")
    check('fork_accept')
    click_button("Criar minha versão desta ideia")
    within '#show_idea' do
      title = find('h2')
      title[:'data-raw'].should == idea.title
      description = find(:xpath, '//p[@data-attribute="headline"]')
      description[:'data-raw'].should == idea.headline
    end
    page.should_not have_link('Melhorar esta ideia')
    idea.reload
    idea.versions.size.should == 1
  end
end