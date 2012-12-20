# coding: utf-8
Given /^I'm a logged user$/ do
  visit "/auth/facebook"
end

Given /^there is an idea called "([^"]*)" that belongs to "([^"]*)"$/ do |arg1, arg2|
  Idea.make!(title: arg1, category: IdeaCategory.find_by_name(arg2), user: Service.make!.user)
end

Given /^there is an idea called "([^"]*)" by "([^"]*)"$/ do |arg1, arg2|
  user = User.find_by_name(arg2)
  user = User.make!(name: arg2) unless user
  idea = Idea.make!(title: arg1, category: IdeaCategory.find_by_name("Mobilidade Urbana"), user: Service.make!(user: user).user)
end

When /^I visit the "([^"]*)" idea page$/ do |arg1|
  idea = Idea.find_by_title(arg1)
  visit category_idea_path(idea.category, idea)
end

When /^I visit the "([^"]*)" by "([^"]*)" idea page$/ do |arg1, arg2|
  visit idea_path(User.find_by_name(arg2).ideas.find_by_title(arg1))
end

Given /^there is an user called "([^"]*)"$/ do |arg1|
  User.make!(name: arg1)
end

Given /^there is an user called "([^"]*)", with email "([^"]*)"$/ do |arg1, arg2|
  User.make!(name: arg1, email: arg2)
end

Given /^"([^"]*)" collaborated on the idea "([^"]*)"$/ do |arg1, arg2|
  @original = Idea.find_by_title(arg2)
  Collaboration.make!(idea: @original, user: User.find_by_name(arg1), description: "Foo bar")
end

Given /^"([^"]*)" collaborated (\d+) times on the idea "([^"]*)"$/ do |user_name, number, idea_title|
  @original = Idea.find_by_title(idea_title)
  @user = User.find_by_name(user_name)
  number.to_i.times do
    Collaboration.make!(idea: @original, user: @user, description: "Foo bar")
  end
end

Given /^I collaborated on the idea "([^"]*)"$/ do |arg1|
  @original = Idea.find_by_title(arg1)
  # TODO: find a better way to get the current_user. Didn't get how to do this
  Collaboration.make!(idea: @original, user: User.first, description: "Foo bar")
end

Given /^I created an idea$/ do
  # TODO: find a better way to get the current_user. Didn't get how to do this
  Idea.make!(user: User.first)
end

When /^I visit the "([^"]*)" user page$/ do |arg1|
  visit user_path(User.find_by_name(arg1))
end

When /^I visit my profile$/ do
  # TODO: find a better way to get the current_user. Didn't get how to do this
  visit user_path(User.first)
end

When /^I visit the timeline page$/ do
  visit timeline_index_path
end

Then /^I should see my name$/ do
  # TODO: find a better way to get the current_user. Didn't get how to do this
  page.should have_content User.first.name
end

Then /^I should see my email$/ do
  # TODO: find a better way to get the current_user. Didn't get how to do this
  page.should have_content User.first.email
end

Then /^show me the page$/ do
  save_and_open_page
end

And /^I click on the link "([^"]*)"$/ do |arg1|
  raise "asdasdas"
  click_link arg1
end

Then /^I should see "([^"]*)" only once$/ do |text|
  page.text.scan(/(#{text})/).size.should == 1
end

Then /^I should see "([^"]*)"$/ do |arg1|
  case arg1
  when "the description message error"
    page.should have_content I18n.t('activerecord.errors.models.idea.attributes.description.blank')
  when "the title message error"
    page.should have_content I18n.t('activerecord.errors.models.idea.attributes.title.blank')
  when "the category message error"
    page.should have_content I18n.t('activerecord.errors.models.idea.attributes.category_id.blank')
  else
    page.should have_content arg1 
  end
end

Then /^I should not see "([^"]*)"$/ do |arg1|
  page.should have_no_content arg1 
end

When /^I fill the collaboration box$/ do
  fill_in "collaboration_description", :with => "Muito legal!"
  sleep(1)
end

When /^I submit the form$/ do
  click_button "Enviar"
  sleep(1)
end

When /^I click in the notifications bar$/ do
  page.execute_script("$('li.notifications .notes').show()")
  sleep(1)
end

############## Institutional videos steps

Given /^(\d+) visible institutional videos exist$/ do |count|
  @institutional_videos = []
  count.to_i.times do |i|
    institutional_video = InstitutionalVideo.make! visible: true, video_url: "http://youtube.com/watch?v=#{i}"
    @institutional_videos << institutional_video
  end
end

Given /^no visible institutional video exists$/ do
  InstitutionalVideo.make! visible: false
end

Then /^I should see the latest video$/ do
  page.find("iframe")[:src].should == InstitutionalVideo.latest.embed_url
end

Then /^I should see the default video$/ do
  page.find("iframe")[:src].should == "http://www.youtube.com/embed/d-laubHNtrI"
end

############## Banners steps

Given /^(\d+) visible banners exist$/ do |count|
  @banners = []
  count.to_i.times do |i|
    banner = Banner.make! visible: true, title: "000#{i}"
    @banners << banner
  end
end

Given /^no visible banner exists$/ do
  Banner.make! visible: false
end

Then /^I should see the latest banner$/ do
  latest = Banner.latest
  banner = page.find(".newsboard")
  banner.find("img")[:src].should == latest.image_url
  banner.find("h2").should have_content(latest.title)
  banner.find("p").should have_content(latest.description)
  banner.find(".right").should have_content(latest.link_text)
  banner.find("a.click_here")[:href].should == latest.link_url
end

Then /^I should see the default banner$/ do
  banner = page.find(".newsboard")
  banner.find("img")[:src].should == "assets/pensar-junto.png"
  banner.find("h2").should have_content("Vamos cocriar?")
  banner.find("p").should have_content("Cocriação é uma forma presencial de criar ideias colaborativamente, todos sabem que duas cabeças pensam melhor do que uma, e é por isso que queremos muitas cabeças pensando nas ideias mais legais que estão por aqui!")
  banner.find(".right").should have_content("Para saber mais e ver as datas das cocriações em SP")
  banner.find("a")[:href].should == "/co-criacao"
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
  click_button "Entrar"
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

And /^I should see a list of blog posts$/ do
  page.should have_content(Blog.fetch_last_posts.first.title)
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

And /^I should see the title as "([^"]*)"$/ do |arg1|
  within 'head title' do
    page.should have_content(arg1)
  end
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
  page.should have_css(".floating_menu ul.user_actions")
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
    visit category_idea_path(@idea.category, @idea)
  else
    raise "I don't know #{arg1}"
  end
end

When /^I click "(.*?)"$/ do |arg1|
  click_link arg1
end

Then /^I should be in "(.*?)"$/ do |arg1|
  case arg1
  when "the login page"
    current_path.should be_== new_session_path
  when "the idea's cocreate page"
    current_path.should be_== cocreate_idea_path(@idea.category, @idea)
  when "the ideas navigation by keyword page"
    sleep(2)
    current_path.should be_== scope_search_path
  when "the new idea page"
    current_path.should be_== new_idea_path
  when "the idea's page"
    current_path.should be_== idea_path(Idea.first)
  else
    raise "I don't know #{arg1}"
  end
end

When /^I press "(.*?)"$/ do |arg1|
  click_button arg1
end

Given /^I am in "(.*?)"$/ do |arg1|
  case arg1
  when "the ideas navigation page"
    visit scope_root_path
  when "the homepage"
    visit root_path
  when "the new idea page"
    visit new_idea_path
  else
    raise "I don't know '#{arg1}'"
  end
end

When /^I fill the idea search form with "(.*?)"$/ do |arg1|
  fill_in "keyword", :with => arg1
  find('input[name=keyword]').native.send_key(:enter)
end

Given /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in arg1, :with => arg2
end

Given /^I choose "(.*?)"$/ do |arg1|
  choose arg1
end

Given /^I check "(.*?)"$/ do |arg1|
  check arg1
end

Given /^I uncheck "(.*?)"$/ do |arg1|
  uncheck arg1
end
