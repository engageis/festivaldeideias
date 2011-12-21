Given /^I'm in the more active ideas page$/ do
  visit ideas_more_active_path
end

Then /^I should see (\w+) $/ do
  page.should have_content("Ideias mais colaboradas")
end
