require 'acceptance/acceptance_helper'

feature 'Footer', %q{
  In order to access content that's not on Ramify
  As a visitor
  I want to see custom links on the footer
} do

  scenario "I visit one site's homepage I should see it's links, but not other sites links" do
    
    site = current_site
    site.links.create :name => "Foo", :title => "Foo Title", :href => 'http://foo.url/'
    site.links.create :name => "Bar", :title => "Bar Title", :href => 'http://bar.url/'
    
    other_site = Site.create(:template => site.template, :name => "Other site", :host => "otherhost")
    other_site.links.create :name => "Other", :title => "Other Title", :href => 'other_url'
    
    visit homepage
    within '#footer .wrapper ul.links' do
      
      link = page.find_link("Foo")
      link[:title].should == "Foo Title"
      link[:href].should == "http://foo.url/"
      
      link = page.find_link("Bar")
      link[:title].should == "Bar Title"
      link[:href].should == "http://bar.url/"
      
      page.should_not have_link("Other")
      
    end
  end

end
