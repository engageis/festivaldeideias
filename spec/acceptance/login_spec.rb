require 'acceptance/acceptance_helper'

feature 'Login', %q{
  In order to access specific parts of the site that require authentication
  As a visitor
  I want to login our signup
} do

  scenario "I open the login page but then I cancel" do
    click_login
    find("#login .overlay").visible?.should be_true
    find("#login .popup").visible?.should be_true
    click_link 'X'
    current_path.should == homepage
    find("#login .overlay").visible?.should be_false
    find("#login .popup").visible?.should be_false
  end

  scenario "I'm new to the site and I want to signup with a supported provider" do
    click_login
    page.should have_link('Google')
    page.should_not have_link('Github')

    fake_login
    page.should have_css('#user_menu')
    page.should have_link(current_user.name)
  end

  scenario "After insertion of a new provider it should appear in the login options" do
    Factory(:oauth_provider)
    sleep 3
    click_login
    page.should have_link('Google')
    page.should have_link('Github')
  end

end
