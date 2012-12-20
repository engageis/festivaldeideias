require 'spec_helper'

describe CollaborationsController do
  describe "GET 'show'" do
    it "returns http success" do
      get :show, id: Collaboration.make!.id
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      @idea = Idea.make!
      post :create, collaboration: { user_id: User.make!.id, idea_id: @idea.id, description: "Foo Club" }
      response.should redirect_to(category_idea_path(@idea.category, @idea))
    end
  end

end
