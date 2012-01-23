require 'spec_helper'

describe NonFacebookUsersController do

  describe "POST #create" do
    before do
      request.env['HTTP_REFERER'] = root_url
      @user = {:email => 'ihatefb@orkut.com' }
      NonFacebookUser.stub!(:create).and_return(@user)
      post :create, :non_facebook_user => @user
    end
    its(:status){ should == 302 }
  end

end
