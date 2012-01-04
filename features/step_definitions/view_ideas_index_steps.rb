Given /^(\d+) category exist$/ do |count|
  @categories = []
  count.to_i.times do |f|
    f = Factory.create(:idea_category)
    @categories << f
  end
end

And /^(\d+) ideas exist$/ do |count|
  @ideas = []
  count.to_i.times do |f|
    f = Factory.create(:idea)
    @ideas << f
  end
end

When /^I visit the ideas index page$/ do
  visit root_path
end

Then /^I should see a list with ideas$/ do
 page.should have_content(@ideas.first.title)
 page.should have_content(@ideas.last.title)
end


And /^I should see a list of categories$/ do
  page.should have_content(@categories.first.name)
  page.should have_content(@categories.last.name)
end


