module HelperMethods
  # Put helper methods you need to be available in all tests here.
  def current_site
    return @current_site if @current_site
    return @current_site = Site.first if Site.first
    unless @current_site
      site_template = Template.first
      site_template = Template.create!(:name => "Template") unless site_template
      @current_site = Site.create!(:template => site_template, :name => "Localhost", :host => "localhost", :port => "3000", :auth_gateway => true)
    end
    @current_site
  end
  def fake_login
    visit fake_login_path
  end
  def current_user
    User.find_by_uid 'fake_login'
  end
  def click_login
    visit homepage
    find("#login .overlay").visible?.should be_false
    find("#login .popup").visible?.should be_false
    page.should have_no_css('#user')
    click_link 'Fazer login'
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
