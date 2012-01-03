Given /^I'm a logged user$/ do
  @user = Factory.create(:user)
  @service = Factory.create(:service, :user => @user)
  current_user = @user
  session[:user_id] = @user.id
end

Given /^(\d+) idea category exist$/ do |count|
  @categories = []
  count.to_i.times do |f|
    f = Factory.create(:idea_category)
    @categories << f
  end
end

Then /^I should see user options$/ do
  page.should have_css('nav ul.actions')
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1.to_s)
end

Then /^I should see a list of notifications$/ do
  page.should have_css('.notes .notifications')
end

Then /^I should see my image$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see my ideas count$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see my colaborations count$/ do
  pending # express the regexp above with the code you wish you had
end
