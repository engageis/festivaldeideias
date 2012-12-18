require 'spec_helper'

describe User do

  describe "Validations/Associations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should have_many :ideas }
    it { should have_many :collaborators }
    it { should have_many(:collaborated_ideas).through(:collaborators) }

    describe "#services" do
      it { should have_many :services }
    end
  end

  describe "#create_from_hash!" do
    fb = FACEBOOK_HASH_DATA
    subject { User.create_from_hash!(FACEBOOK_HASH_DATA) }
    its(:email){ should == fb['info']['email']}
    its(:name) { should == fb['info']['name']}
  end


  describe "#new_notifications_count" do
    before do
      # The user read its notifications yesterday
      @user = User.make!(notifications_read_at: Time.now - 1.day)

      # TODO 
      # Covers the case: "When the idea receives a new collaboration."
      # Covers the case: "When collaboration status changes"

    end
    subject { @user.new_notifications_count }
    it { should == 3 }
  end
end
