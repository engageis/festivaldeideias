Given /^(\d+) ideas exist$/ do |count|
  @ideas = []
  count.to_i.times do |f|
    f = Factory.create(:idea)
    @ideas << f
  end
end

When /^I visit the ideas index page$/ do
  visit ideas_path
end

Then /^I should see a list with ideas$/ do
 page.should have_content(@ideas.first.title)
 page.should have_content(@ideas.last.title)
end

