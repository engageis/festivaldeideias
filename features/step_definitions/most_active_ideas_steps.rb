Given /^I'm in the most active ideas page$/ do
  visit most_active_ideas_path
end

Then /^I should see "([^"]*)"$/ do |title|
  page.should have_content(title)
end
