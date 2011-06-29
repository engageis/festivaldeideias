require 'spec_helper'

describe OauthProvider do

  it "should be valid from factory" do
    o = Factory(:oauth_provider)
    o.should be_valid
  end
  
end
