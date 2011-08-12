require 'acceptance/acceptance_helper'

feature 'Create idea', %q{
  In order to create a new idea
  As a user
  I want to access the new idea form, and submit my idea
} do
  
  scenario "create a new idea" do
    category = Factory.build(:category, :site_id => current_site.id)
    category.save
    fake_login
    click_link("Inicie uma ideia")
    within "#new_idea" do
      fill_in('idea_title', :with => 'foo idea')
      fill_in('idea_headline', :with => 'foo idea headline')
      choose("idea_category_id_#{category.id}")
      check('new_accept')
      click_button('idea_submit')
    end

    within '#show_idea' do
      title = find('h2')
      title[:'data-raw'].should == 'foo idea'
      description = find(:xpath, '//p[@data-attribute="headline"]')
      description[:'data-raw'].should == 'foo idea headline'
    end
  end
  
  scenario "should not be able to create an idea without title" do
    category = Factory.build(:category, :site_id => current_site.id)
    category.save
    fake_login
    click_link("Inicie uma ideia")
    within "#new_idea" do
      fill_in('idea_headline', :with => 'foo idea headline')
      choose("idea_category_id_#{category.id}")
      check('new_accept')
      find('#idea_submit')['disabled'].should == "true"
    end
  end

  scenario "should not be able to create an idea without headline" do
    category = Factory.build(:category, :site_id => current_site.id)
    category.save
    fake_login
    click_link("Inicie uma ideia")
    within "#new_idea" do
      fill_in('idea_title', :with => 'foo idea')
      choose("idea_category_id_#{category.id}")
      check('new_accept')
      find('#idea_submit')['disabled'].should == "true"
    end
  end

  scenario "should not be able to create an idea without category" do
    category = Factory.build(:category, :site_id => current_site.id)
    category.save
    fake_login
    click_link("Inicie uma ideia")
    within "#new_idea" do
      fill_in('idea_title', :with => 'foo idea')
      fill_in('idea_headline', :with => 'foo idea headline')
      check('new_accept')
      find('#idea_submit')['disabled'].should == "true"
    end
  end

  scenario "should not be able to create an idea without accepting license terms" do
    category = Factory.build(:category, :site_id => current_site.id)
    category.save
    fake_login
    click_link("Inicie uma ideia")
    within "#new_idea" do
      fill_in('idea_title', :with => 'foo idea')
      fill_in('idea_headline', :with => 'foo idea headline')
      choose("idea_category_id_#{category.id}")
      find('#idea_submit')['disabled'].should == "true"
    end
  end

  scenario "should see login options when trying to create an idea without being logged in" do
    visit root_path
    click_link("Inicie uma ideia")
  end
end