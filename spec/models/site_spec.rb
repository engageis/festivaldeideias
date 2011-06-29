require 'spec_helper'

describe Site do

  it "should be valid from factory" do
    o = Factory(:site)
    o.should be_valid
  end
  
  it "should have a template" do
    o = Factory.build(:site, :template => nil)
    o.should_not be_valid
  end
  
  it "should have a name" do
    o = Factory.build(:site, :name => nil)
    o.should_not be_valid
  end
  
  it "should have a host" do
    o = Factory.build(:site, :host => nil)
    o.should_not be_valid
  end
  
  it "should have an unique name" do
    Factory(:site, :name => "foo")
    o = Factory.build(:site, :name => "foo")
    o.should_not be_valid
  end
  
  it "should have an unique host" do
    Factory(:site, :host => "foo")
    o = Factory.build(:site, :host => "foo")
    o.should_not be_valid
  end
  
  it "should have users" do
    o = Factory(:site)
    u = Factory(:user, :site => o)
    o.users.should == [u]
  end
  
  it "should have a global auth_gateway" do
    gateway = Factory(:site, :auth_gateway => true)
    o = Factory(:site)
    Site.auth_gateway.should == gateway
  end
  
  it "should have a full url, with optional path" do
    o = Factory(:site, :host => "foo.com", :port => "8080")
    o.full_url.should == "http://foo.com:8080"
    o.full_url("/my_path?my_param=foobar").should == "http://foo.com:8080/my_path?my_param=foobar"
  end
  
end
