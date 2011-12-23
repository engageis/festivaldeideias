require 'spec_helper'

describe User do

  describe "Validations/Associations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }

    describe "#services" do
      it { should have_many :services }
    end
  end
end
