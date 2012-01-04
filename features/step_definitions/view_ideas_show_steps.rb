#
# Given step is in the Idea index step definition
#
Then /^I follow the link "([^"]*)"$/ do |arg1|
  page.should have_link(arg1)
  click_link "#{arg1}"
end

And /^I should see the idea's title$/ do
  page.should have_content(@ideas.first.title)
end

Then /^I should see the idea's description$/ do
  page.should have_content(@ideas.first.description)
end

And /^I should see a link "([^"]*)"$/ do |arg1|
  page.should have_link(arg1)
end
