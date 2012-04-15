# coding: utf-8

And /^(\d+) pages exist$/ do |count|
  count.to_i.times { |counter|
    FactoryGirl.create(:page, :title => "Página #{counter}",   :body => "<p>Página #{counter}</p>")
  }
end

Then /^I should see (\d+) links to pages$/ do |count|
  count = count.to_i
  page.should have_css('.page_links li a', :count => count)
end
