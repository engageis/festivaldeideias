class IdeasController < InheritedResources::Base

  respond_to :html, :json
  optional_belongs_to :category
  before_filter :load_resources

  def navigate
  end

  def load_resources
    @categories ||= IdeaCategory.order(:name).all(:include => :ideas)
    @users ||= User.all(:include => :services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.order(:updated_at).all
    @ideas_featured ||= Idea.order(:likes).all
  end
end
