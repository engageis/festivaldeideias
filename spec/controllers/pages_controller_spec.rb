require 'spec_helper'

describe PagesController do
  before do
    @page = create(:page)
  end

  describe "GET #index" do
    before do
      get :show, :id => @page.slug
    end

    its(:status) { should == 200 }
  end

end

