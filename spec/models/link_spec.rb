require 'spec_helper'

describe Link do

  it "should be valid from factory" do
    o = Factory(:link)
    o.should be_valid
  end
  
  it "should have a site" do
    o = Factory.build(:link, :site => nil)
    o.should_not be_valid
  end
  
  it "should have a name" do
    o = Factory.build(:link, :name => nil)
    o.should_not be_valid
  end
  
  it "should have a href" do
    o = Factory.build(:link, :href => nil)
    o.should_not be_valid
  end
  
end
