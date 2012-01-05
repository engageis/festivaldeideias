class IdeasController < InheritedResources::Base

  respond_to :html, :json
  optional_belongs_to :category
  before_filter :load_resources, :only => [:index, :show, :edit]

  def navigate
  end

  def load_resources
    @categories = IdeaCategory.order(:name).all(:include => :ideas)
  end
end
