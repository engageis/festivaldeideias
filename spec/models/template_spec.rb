require 'spec_helper'

describe Template do

  it "should be valid from factory" do
    o = Factory(:template)
    o.should be_valid
  end
  
  it "should have a name" do
    o = Factory.build(:template, :name => nil)
    o.should_not be_valid
  end
  
  it "should have an unique name" do
    Factory(:template, :name => "foo")
    o = Factory.build(:template, :name => "foo")
    o.should_not be_valid
  end
  
end
