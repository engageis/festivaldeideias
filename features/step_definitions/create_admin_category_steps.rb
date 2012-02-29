Then /^I click the link "([^"]*)"$/ do |arg1|
  click_link(arg1)
end

Then /^I fill the form with my category data$/ do
  within "#idea_category_new" do
    #fill_in "idea_category_name", :with => "Sample"
    fill_in "idea_category_description", :with => "Description"
    attach_file "idea_category_badge", "#{Rails.root}/spec/fixtures/images/disasters.png"
  end
  #click_button "Create Idea category"
  click_button "Create Categoria"
end

Then /^I should be redirected to "([^"]*)"$/ do |arg1|
  current_path.should == eval(arg1)
end

