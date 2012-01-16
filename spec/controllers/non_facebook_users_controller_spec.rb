=begin
require 'spec_helper'

describe NonFacebookUsersController do

  describe "POST #create" do
    before do
      request.env['HTTP_REFERER'] = root_url
    end

    it "should create a new non_facebook_user" do
      NonFacebookUser.should_receive(:create).with({ :email => 'ihatefb@orkut.com' })
      post 'create', :non_facebook_user => { 'email' => 'ihatefb@orkut.com' }
    end
  end

end
=end
