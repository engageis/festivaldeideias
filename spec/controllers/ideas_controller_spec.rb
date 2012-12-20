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

end
