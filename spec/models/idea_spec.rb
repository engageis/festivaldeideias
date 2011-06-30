require 'spec_helper'

describe Idea do

  it "should be valid from factory" do
    o = Factory(:idea)
    o.should be_valid
  end
  
  it "should have a site" do
    o = Factory.build(:idea, :site => nil)
    o.should_not be_valid
  end
  
  it "should have a user" do
    o = Factory.build(:idea, :user => nil)
    o.should_not be_valid
  end
  
  it "should have a category" do
    o = Factory.build(:idea, :category => nil)
    o.should_not be_valid
  end
  
  it "should have a template" do
    o = Factory.build(:idea, :template => nil)
    o.should_not be_valid
  end
  
  it "should have a title" do
    o = Factory.build(:idea, :title => nil)
    o.should_not be_valid
    o = Factory.build(:idea, :title => "")
    o.should_not be_valid
  end
  
  it "should have a headline" do
    o = Factory.build(:idea, :headline => nil)
    o.should_not be_valid
    o = Factory.build(:idea, :headline => "")
    o.should_not be_valid
  end
  
  it "should not be valid with a headline longer than 140 characters" do
    o = Factory.build(:idea)
    o.headline = "a".center(139)
    o.should be_valid
    o.headline = "a".center(140)
    o.should be_valid
    o.headline = "a".center(141)
    o.should_not be_valid
  end
  
  it "should have a parent object, if it has a parent_id" do
    parent = Factory(:idea)
    o = Factory(:idea, :parent => parent)
    o.parent.should == parent
  end
  
end
