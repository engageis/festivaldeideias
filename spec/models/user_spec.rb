require 'spec_helper'

describe User do

  describe "Validations/Associations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should have_many :ideas }
    it { should have_many :colaborations }

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
end
