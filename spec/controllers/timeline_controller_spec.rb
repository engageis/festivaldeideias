require 'spec_helper'

describe TimelineController do

  describe "GET #index" do
    before do
      get :index
    end
    its(:status) { should == 200 }
  end

end
