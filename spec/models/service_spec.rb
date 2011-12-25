require 'spec_helper'

describe Service do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :user }


  describe "#user" do
    it { should belong_to :user }
  end

  describe "#find_from_hash" do
    it "Should find the provider and UID when it's already in database" do
      fb = FACEBOOK_HASH_DATA
      service = Factory.create(:service, :provider => fb['provider'], :uid => fb['uid'])
      Service.find_from_hash(fb).should == service
    end

    it "Should return false if the provider/uid isn't in the DB" do
      Service.find_from_hash(FACEBOOK_HASH_DATA).should == nil
    end
  end
end
