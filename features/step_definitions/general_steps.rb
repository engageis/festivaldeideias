# coding: utf-8
Given /^I'm a logged user$/ do
  visit "/auth/facebook"
end

Given /^There is a category called "([^"]*)"$/ do |arg1|
 IdeaCategory.make!(name: arg1)
end

Given /^There is a idea called "([^"]*)" that belongs to "([^"]*)"$/ do |arg1, arg2|
 Idea.make!(title: arg1, category: IdeaCategory.make!(name: arg2), user: Service.make!.user)
end

When /^I visit the root path$/ do
  visit root_path
end

And /^I click on the link "([^"]*)"$/ do |arg1|
  click_link arg1
end
Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content arg1 
end

When /^I fill the form$/ do
  within ".new_idea" do
    fill_in "Sabe de um título melhor? Colabore aqui:", with: "My collab"
    fill_in "Algo a adicionar? Aqui é o corpo da ideia, colabore alterando e/ou adicionando seus pontos:", with: "My collab desc"
    fill_in "idea_minimum_investment", with: "500000"
  end
end

When /^I submit the form$/ do
  click_button "Enviar colaboração!"
end

Given /^I made a colaboration called "([^"]*)" in the idea "([^"]*)" and it was ([^"]*)$/ do |arg1, arg2, arg3|
  flag = nil
  if arg3 == "accepted" 
    flag = true
  elsif arg3 == "rejected"
    flag = false
  end
  @original = Idea.find_by_title(arg2)
  @my_colaboration = Idea.make!(title: arg1, parent: @original, category: @original.category, user: User.find_by_name("Luiz Fonseca"), accepted: flag)
end

When /^I click in the notifications bar$/ do
  page.execute_script("$('li.notifications .notes').show()")
  sleep(1)
end



############## Admin Steps

Given /^I'm an admin user$/ do
  @user = AdminUser.make!
end

When /^I go to the admin index page$/ do
  visit admin_dashboard_url
end

When /^I fill the admin login form with my information$/ do
  within "#session_new" do
    fill_in "admin_user_email", :with => @user.email
    fill_in "admin_user_password", :with => "password" 
  end
  click_button "Login"
end

Then /^I should be in the "([^"]*)"$/ do |arg|
  current_path.should == eval(arg)
end


## Random steps

Given /^(\d+) category exist$/ do |count|
  @categories = []
  count.to_i.times do |f|
    f = IdeaCategory.make!
    @categories << f
  end
end

And /^(\d+) ideas exist$/ do |count|
  @ideas = []
  @user = Service.make!.user

  count.to_i.times do |f|
    f = Idea.make!(:user => @user, category: @categories.first)
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

Then /^I click the idea title$/ do
  click_link "#{@ideas.first.title}"
end

And /^I should see a list of categories$/ do
  page.should have_content(@categories.first.name)
  page.should have_content(@categories.last.name)
end

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


And /^(\d+) pages exist$/ do |count|
  count.to_i.times { |counter|
    Page.make!(:title => "Página #{counter}",   :body => "<p>Página #{counter}</p>")
  }
end

Then /^I should see (\d+) links to pages$/ do |count|
  count = count.to_i
  page.should have_css('.page_links li a', :count => count)
end


Then /^I should see user options$/ do
  page.should have_xpath("//div[@class='wrapper']/ul[@class='user_actions']")
end

Then /^I should see a list of notifications$/ do
  page.should have_css('.user_actions .notifications ul.notifications')
end

Then /^I should see my profile image$/ do
  page.should have_xpath("//img[@class='medium_profile_image']")
end

Given /^there is an idea$/ do
  @idea = Idea.make!
end

Given /^I'm in "(.*?)"$/ do |arg1|
  if arg1 == "this idea page"
    visit idea_path(@idea)
  else
    raise "I don't know #{arg1}"
  end
end

When /^I click "(.*?)"$/ do |arg1|
  click_link arg1
end

Then /^I should be in "(.*?)"$/ do |arg1|
  if arg1 == "the login page"
    current_path.should be_== new_session_path
  elsif arg1 == "the idea's cocreate page"
    current_path.should be_== cocreate_idea_path(@idea.category, @idea)
  elsif arg1 == "the ideas navigation by keyword page"
    sleep(2)
    current_path.should be_== scope_search_path
  else
    raise "I don't #{arg1}"
  end
end

When /^I press "(.*?)"$/ do |arg1|
  click_button arg1
end

Given /^I am in "(.*?)"$/ do |arg1|
  if(arg1 == "the ideas navigation page")
    visit scope_root_path
  else
    raise "I don't know '#{arg1}'"
  end
end

When /^I fill the idea search form with "(.*?)"$/ do |arg1|
  fill_in "keyword", :with => arg1
  find('input[name=keyword]').native.send_key(:enter)
end
