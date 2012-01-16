require 'spec_helper'

describe IdeasController do

  #describe "GET #index" do
    #before do
      #get :index
    #end
    #its(:status) { should == 200 }
  #end


  describe "POST #create" do
    before do
      request.env['HTTP_REFERER'] = root_url
      @category = Factory.create(:idea_category)
      @user = Factory.create(:service).user
      idea = { :title => "Just a test dude", :headline => "Headline test", :description => "Hey, I'm a test", }

      controller.stub(:current_user).and_return(@user)

      post :create, :category_id => @category.id, :idea => idea
    end

    its(:status) { should == 302 }
    it { should redirect_to :back }
  end

end
