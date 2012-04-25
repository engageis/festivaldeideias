require 'spec_helper'

describe NonFacebookUser do
  before do
    NonFacebookUser.make! 
  end

  describe "Validations" do
    it { should validate_presence_of :email }
  end
end
