require 'spec_helper'

describe SessionsController do
  describe "POST #create" do
    before do
      @auth = FACEBOOK_HASH_DATA
      request.env['omniauth.auth'] = @auth
      post :create, :provider => :facebook
    end
    context "When the user is not yet in the service list" do
      before do
        Service.stub(:find_from_hash).and_return(false)
        @hash = Service.stub(:create_from_hash).and_return("current_user")
      end
      it { should redirect_to root_path }
    end
    context "When the user is in the service list" do
      before do
        @auth = create(:service, :uid => FACEBOOK_HASH_DATA["uid"])
        Service.stub(:find_from_hash).and_return(true)
      end
      it { should redirect_to root_path }
    end
  end
end
