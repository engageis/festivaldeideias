require 'spec_helper'

describe Category do
  
  it "should be valid from factory" do
    c = Factory(:category)
    c.should be_valid
  end
  
  it "should have a name" do
    c = Factory.build(:category, :name => nil)
    c.should_not be_valid
  end
  
  it "should have a badge" do
    c = Factory.build(:category, :badge => nil)
    c.should_not be_valid
  end
  
  it "should have an unique name for each site" do
    s1 = Factory(:site)
    s2 = Factory(:site)
    c = Factory(:category, :name => "foo", :site => s1)
    c.should be_valid
    c2 = Factory.build(:category, :name => "foo", :site => s1)
    c2.should_not be_valid
    c2 = Factory.build(:category, :name => "foo", :site => s2)
    c2.should be_valid
  end
  
end

