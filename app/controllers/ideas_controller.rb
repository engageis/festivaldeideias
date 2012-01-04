class IdeasController < InheritedResources::Base

  respond_to :html, :json
  before_filter :load_categories, :only => [:index, :show, :edit]

  def navigate
  end

  def load_categories
    @categories = IdeaCategory.order(:name).all(:include => :ideas)
  end
end
