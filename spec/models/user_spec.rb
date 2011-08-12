require 'spec_helper'

describe User do
  
  it "should be valid from factory" do
    o = Factory(:user)
    o.should be_valid
  end
  
  it "User.primary should return all primary users" do
    o = Factory(:user)
    secondary = Factory(:user, :primary_user_id => o.id)
    User.primary.all.should == [o]
  end
  
  it "primary should return the primary user for this instance" do
    o = Factory(:user)
    secondary = Factory(:user, :primary_user_id => o.id)
    secondary.primary.should == o
  end
  
  it "secondary_users should return the secondary users for this instance" do
    o = Factory(:user)
    secondary = Factory(:user, :primary_user_id => o.id)
    another_user = Factory(:user, :primary_user_id => o.id)
    Set.new(o.secondary_users).should == Set.new([secondary, another_user])
  end
  
  it "even if we already have a user with the same email it should NOT be automatically associated with the first user" do
    o = Factory(:user)
    secondary = Factory(:user, :email => o.email)
    secondary.primary_user_id.should == nil
    another_user = Factory(:user, :email => o.email)
    another_user.primary_user_id.should == nil
  end
  
  it "should have a provider" do
    o = Factory.build(:user, :provider => nil)
    o.should_not be_valid
  end
  
  it "should have an uid" do
    o = Factory.build(:user, :uid => nil)
    o.should_not be_valid
  end
  
  it "should have a site" do
    o = Factory.build(:user, :site => nil)
    o.should_not be_valid
  end
  
  it "should not have duplicate provider and uid" do
    o = Factory.build(:user, :provider => "twitter", :uid => "123456")
    o.should be_valid
    o.save
    o = Factory.build(:user, :provider => "twitter", :uid => "123456")
    o.should_not be_valid
  end
  
  it "should allow empty email" do
    o = Factory.build(:user)
    o.email = ""
    o.should be_valid
    o.email = nil
    o.should be_valid
  end
  
  it "should check email format" do
    o = Factory.build(:user)
    o.email = "foo"
    o.should_not be_valid
    o.email = "foo@bar"
    o.should_not be_valid
    o.email = "foo@bar.com"
    o.should be_valid
  end
  
  it "should not be valid with a bio longer than 140 characters" do
    o = Factory.build(:user)
    o.bio = "a".center(139)
    o.should be_valid
    o.bio = "a".center(140)
    o.should be_valid
    o.bio = "a".center(141)
    o.should_not be_valid
  end
  
  it "should create and associate user passed as parameter if passed" do
    primary = Factory(:user)
    auth = {
      'provider' => "twitter",
      'uid' => "foobar",
      'user_info' => {
        'name' => "Foo bar",
        'email' => 'another_email@catarse.me',
        'nickname' => "foobar",
        'description' => "Foo bar's bio".ljust(200),
        'image' => "user.png"
      }
    }
    o = User.create_with_omniauth(Factory(:site), auth, primary.id)
    o.should == primary
    User.count.should == 2
  end
  
  it "should have a find_with_omniauth who finds always the primary" do
    primary = Factory(:user)
    secondary = Factory(:user, :primary_user_id => primary.id)
    User.find_with_omni_auth(primary.provider, primary.uid).should == primary
    User.find_with_omni_auth(secondary.provider, secondary.uid).should == primary
    # If user does not exist just returns nil
    User.find_with_omni_auth(secondary.provider, 'user that does not exist').should == nil
  end
  
  it "should create a new user receiving a omniauth hash" do
    auth = {
      'provider' => "twitter",
      'uid' => "foobar",
      'user_info' => {
        'name' => "Foo bar",
        'nickname' => "foobar",
        'description' => "Foo bar's bio".ljust(200),
        'image' => "user.png"
      }
    }
    o = User.create_with_omniauth(Factory(:site), auth)
    o.should be_valid
    o.provider.should == auth['provider']
    o.uid.should == auth['uid']
    o.name.should == auth['user_info']['name']
    o.nickname.should == auth['user_info']['nickname']
    o.bio.should == auth['user_info']['description'][0..139]
    # Commented because image_url column name conflicts with Carrier Wave
    #o.image_url.should == auth['user_info']['image']
  end
  
  it "should have a display_name that shows the name, nickname or 'Sem nome'" do
    o = Factory(:user, :name => "Name")
    o.display_name.should == "Name"
    o = Factory(:user, :name => nil, :nickname => "Nickname")
    o.display_name.should == "Nickname"
    o = Factory(:user, :name => nil, :nickname => nil)
    o.display_name.should == "Sem nome"
  end
  
  it "should have a display_image that shows the user's image or user.png when email is null" do
    # Commented because image_url column name conflicts with Carrier Wave
    #o = Factory(:user, :image_url => "image.png", :email => nil)
    #o.display_image.should == "image.png"
    o = Factory(:user, :image_url => nil, :email => nil)
    o.display_image.should == "/images/user.png"
  end
  
  it "should insert a gravatar in user's image if there is one available" do
    o = Factory(:user, :image_url => nil, :email => 'diogob@gmail.com')
    o.display_image.should == "http://gravatar.com/avatar/5e2a237dafbc45f79428fdda9c5024b1.jpg?default=http://catarse.me/images/user.png"
  end
  
  it "should have a remember_me_hash with the MD5 of the provider + ## + uid" do
    o = Factory(:user, :provider => "foo", :uid => "bar")
    o.remember_me_hash.should == "27fc6690fafccbb0fc0b8f84c6749644"
  end
  
end
