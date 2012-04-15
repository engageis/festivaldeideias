require 'spec_helper'

describe NonFacebookUser do
  before do
    create :non_facebook_user
  end

  describe "Validations" do
    it { should validate_presence_of :email }
  end
end
