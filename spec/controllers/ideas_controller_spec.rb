require 'spec_helper'

describe IdeasController do

  describe "GET #index" do
    before do
      get :index
    end
    its(:status) { should == 200 }
  end


  describe "POST #create" do
    before do
      request.env['HTTP_REFERER'] = root_url
      @category = create(:idea_category)
      @user = create(:service).user
      idea = { :title => "Just a test dude", :headline => "Headline test", :description => "Hey, I'm a test", }

      controller.stub(:current_user).and_return(@user)

      post :create, :category_id => @category.id, :idea => idea
    end

    its(:status) { should == 302 }
    it { should redirect_to :back }
  end

  describe "GET #show" do
    before do
      @idea = create(:idea)
      get :show, :id => @idea.id

    end
    its(:status) { should == 200 }
  end

  describe "put #colaborate" do
    before do
      @user = create(:user)
      @new_user = create(:user, :name => "Tester")
      @idea = create(:idea, :user => @user)
      controller.stub(:current_user).and_return(@new_user)
      idea = {"headline" => "Test", "description" => "test", "title" => "test", "parent_id" => @idea.id.to_s}
      Idea.should_receive(:create_colaboration).with(idea.merge("user_id" => @new_user.id))
      put :colaborate, :id => @idea.id, :idea => idea
    end

    its(:status){ should == 302 }
    it { should redirect_to category_idea_path(@idea.category.id, @idea)}

  end
end
