class IdeasController < ApplicationController

  inherit_resources

  actions :index, :show, :create
  respond_to :html
  respond_to :json, :only => [:index]
  
  def index
    index! do |format|
      format.html do
        @featured = current_site.ideas.featured.limit(4).all
        @popular = current_site.ideas.not_featured.popular.limit(4).all
        @recent = current_site.ideas.not_featured.recent.limit(4).all
        @count = current_site.ideas.count
      end
      format.json do
        @ideas = current_site.ideas.search(params[:search]).page params[:page]
        render :json => @ideas.to_json
      end
    end
  end
  
  def create
    return unless require_login
    @idea = Idea.new(params[:idea])
    @idea.site = current_site
    @idea.user = current_user
    @idea.template = current_site.template
    create!
  end
  
  def explore
    @categories = current_site.categories.with_ideas.order(:name).all
  end
  
end
