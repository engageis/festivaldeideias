# coding: utf-8
Given /^I'm a logged user$/ do
  visit "/auth/facebook"
end

Given /^There is a category called "([^"]*)"$/ do |arg1|
 IdeaCategory.make!(name: arg1)
end

Given /^There is a idea called "([^"]*)" that belongs to "([^"]*)"$/ do |arg1, arg2|
 Idea.make!(title: arg1, category: IdeaCategory.find_by_name(arg2))
end

When /^I visit the root path$/ do
  visit root_path
end

And /^I click on the link "([^"]*)"$/ do |arg1|
  click_link arg1
end
