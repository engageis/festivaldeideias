require 'spec_helper'

describe User do

  describe "Validations/Associations" do
    before do
      @user = Factory.create(:user)
    end

    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should have_many :services }
  end
end
