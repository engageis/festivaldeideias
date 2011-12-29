class IdeasController < InheritedResources::Base
  def index
    @ideas = Idea.order(:name).page params[:page]
  end
end
