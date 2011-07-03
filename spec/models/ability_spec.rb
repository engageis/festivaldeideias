require 'spec_helper'
require "cancan/matchers"

describe Category do

  it "should enable root user to manage everything" do
    user = Factory.build(:user, :admin => true)
    user2 = Factory.build(:user)
    site = Factory.build(:site)
    site2 = Factory.build(:site)
    user2.sites << site2
    category = Factory.build(:category)
    ability = Ability.new(user)
    ability.should be_able_to(:manage, Site)
    ability.should be_able_to(:destroy, site2)
    ability.should be_able_to(:manage, category)
    ability.should be_able_to(:manage, user2)
    ability.should be_able_to(:manage, Configuration)
  end

  it "should enable site admin to manage only his site" do
    site1 = Factory.build(:site)
    site2 = Factory.build(:site)
    user = Factory.build(:user)
    user.sites << site1
    ability = Ability.new(user)
    ability.should_not be_able_to(:manage, site2)
    ability.should_not be_able_to(:destroy, site2)
    ability.should_not be_able_to(:create, Site)
    ability.should be_able_to(:manage, site1)
  end
  
  it "should enable site admin to manage only his site contents" do
    site1 = Factory.build(:site)
    site2 = Factory.build(:site)
    user = Factory.build(:user)
    user.save
    user.sites << site1
    ability = Ability.new(user)
  
    category1 = Factory.build(:category, :site => site1)
    category2 = Factory.build(:category, :site => site2)
    ability.should be_able_to(:manage, category1)
    ability.should_not be_able_to(:manage, category2)
    
    idea1 = Factory.build(:idea, :site => site1)
    idea2 = Factory.build(:idea, :site => site2)
    ability.should be_able_to(:manage, idea1)
    ability.should_not be_able_to(:manage, idea2)
  end
  
  it "should not enable ordinary users to manage sites, categories and other's ideas" do
    site1 = Factory.build(:site)
    user1 = Factory.build(:user, :site => site1)
    user2 = Factory.build(:user, :site => site1)
    user1.save
    user2.save
    idea1 = Factory.build(:idea, :site => site1, :user => user1)
    idea2 = Factory.build(:idea, :site => site1, :user => user2)
    ability = Ability.new(user1)
    
    ability.should_not be_able_to(:manage, user2)
    ability.should_not be_able_to(:manage, idea2)
    ability.should be_able_to(:manage, user1)
    ability.should be_able_to(:manage, idea1)
  end

end