# coding: utf-8
Given /^I'm a logged user$/ do
  visit "/auth/facebook"
end

Given /^There is a category called "([^"]*)"$/ do |arg1|
 IdeaCategory.make!(name: arg1)
end

Given /^There is a idea called "([^"]*)" that belongs to "([^"]*)"$/ do |arg1, arg2|
 Idea.make!(title: arg1, category: IdeaCategory.find_by_name(arg2), user: Service.make!.user)
end

When /^I visit the root path$/ do
  visit root_path
end

And /^I click on the link "([^"]*)"$/ do |arg1|
  click_link arg1
end
Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content arg1 
end

When /^I fill the form$/ do
  within ".new_idea" do
    fill_in "Colabore no titulo desta ideia", with: "My collab"
    fill_in "Colabore na descrição desta ideia", with: "My collab desc"
    fill_in "idea_minimum_investment", with: "500000"
  end
end

When /^I submit the form$/ do
  click_button "Publicar!"
end

Given /^I made a colaboration called "([^"]*)" in the idea "([^"]*)" and it was ([^"]*)$/ do |arg1, arg2, arg3|
  flag = nil
  if arg3 == "accepted" 
    flag = true
  elsif arg3 == "rejected"
    flag = false
  end
  @original = Idea.find_by_title(arg2)
  @my_colaboration = Idea.make!(title: arg1, parent: @original, category: @original.category, user: User.find_by_name("Luiz Fonseca"), accepted: flag)
end

When /^I click in the notifications bar$/ do
  page.execute_script("$('li.notifications').trigger('click')")
end
