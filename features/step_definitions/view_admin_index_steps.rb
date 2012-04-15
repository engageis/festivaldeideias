Given /^I'm an admin user$/ do
  @user = FactoryGirl.create(:admin_user)
end

When /^I go to the admin index page$/ do
  visit admin_dashboard_url
end

When /^I fill the admin login form with my information$/ do
  within "#session_new" do
    fill_in "admin_user_email", :with => @user.email
    fill_in "admin_user_password", :with => "super_safe"
  end
  click_button "Login"
end

Then /^I should be in the "([^"]*)"$/ do |arg|
  current_path.should == eval(arg)
end

