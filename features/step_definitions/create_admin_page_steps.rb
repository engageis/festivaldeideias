# coding: utf-8

Then /^I fill the form with my page data$/ do
  within "#page_new" do
    fill_in "page_title", :with => 'Minha Página'
    fill_in 'page_body', :with => '<p>Texto da página</p>'
  end

  click_button "Create Página"
end
