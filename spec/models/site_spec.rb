require 'spec_helper'

describe Site do

  it "should be valid from factory" do
    o = Factory(:site)
    o.should be_valid
  end
  
  it "should have a name" do
    o = Factory.build(:category, :name => nil)
    o.should_not be_valid
  end
  
end
