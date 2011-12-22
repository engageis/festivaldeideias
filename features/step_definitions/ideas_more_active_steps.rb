Given /^I'm in the more active ideas page$/ do
  visit ideas_more_active_path
end

Then /^I should see "([^"]*)"$/ do |title|
  page.should have_content(title)
end
