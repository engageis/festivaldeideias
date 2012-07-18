require 'spec_helper'

describe IdeasController do

  describe "GET #index" do
    before do
      get :index
    end
    its(:status) { should == 200 }
  end

  describe "GET #show" do
    before do
      @idea = Idea.make!
      get :show, :id => @idea.id

    end
    its(:status) { should == 200 }
  end

  describe "put #colaborate" do
    before do
      @user = User.make!
      @new_user = User.make!(:name => "Tester")
      @idea = Idea.make!(:user => @user)
      controller.stub(:current_user).and_return(@new_user)
      idea = {"headline" => "Test", "description" => "test", "title" => "test", "parent_id" => @idea.id.to_s}
      Idea.should_receive(:create_colaboration).with(idea.merge("user_id" => @new_user.id))
      put :colaborate, :id => @idea.id, :idea => idea
    end

    its(:status){ should == 302 }
    it { should redirect_to category_idea_path(@idea.category.id, @idea)}

  end


  describe "put #message" do
    before do
      @user = User.make!
      @idea = Idea.make!
      controller.stub(:current_user).and_return(@user)

    end
  end
end
