Given /^I'm a logged user$/ do
  @user = FactoryGirl.create(:user, :email => "runeroniek@gmail.com")
  @service = FactoryGirl.create(:service, :provider => "facebook", :uid =>"547955110", :user => @user)
  visit '/auth/facebook'
end

Given /^(\d+) idea category exist$/ do |count|
  @categories = []
  count.to_i.times do |f|
    f = FactoryGirl.create(:idea_category)
    @categories << f
  end
end


Then /^I should see user options$/ do
  page.should have_xpath("//div[@class='wrapper']/ul[@class='user_actions']")
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1.to_s)
end

Then /^I should see a list of notifications$/ do
  page.should have_css('.user_actions .notifications ul.notifications')
end

Then /^I should see my profile image$/ do
  page.should have_xpath("//ul[@class='user_actions']/li[@class='logged_in']/div[@class='user_menu']/img[@class='medium_profile_image']")
end

Then /^I should see my ideas count$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see my colaborations count$/ do
  pending # express the regexp above with the code you wish you had
end
