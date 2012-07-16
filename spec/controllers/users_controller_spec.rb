require 'spec_helper'

describe UsersController do

  describe "GET #show" do
    
    context "with guest user" do
      before do
        @user = Service.make!.user
        get :show, id: @user.id
      end
      its(:status) { should == 200 }
    end

    context "with logged user" do
      before do
        @user = Service.make!.user
        controller.stub(:current_user).and_return(@user)
        get :show, id: @user.id
      end
      its(:status) { should == 200 }
    end
    
  end

  describe "GET #notifications" do
    
    context "with guest user" do
      before do
        get :notifications
      end
      its(:status) { should == 302 }
    end
    context "with logged user" do
      before do
        @user = Service.make!.user
        controller.stub(:current_user).and_return(@user)
        get :notifications
      end
      its(:status) { should == 200 }
    end
    
  end

  describe "PUT #update_notification" do
    
    context "with guest user" do
      before do
        put :update_notification
      end
      its(:status) { should == 302 }
    end
    context "with logged user" do
      before do
        @user = Service.make!.user
        controller.stub(:current_user).and_return(@user)
        put :update_notification
      end
      its(:status) { should == 200 }
    end
    
  end

end
