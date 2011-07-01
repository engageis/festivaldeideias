class IdeasController < ApplicationController

  inherit_resources
  
  def index
    @featured = Idea.featured.limit(4).all
    @popular = Idea.not_featured.popular_home.all
    @recent = Idea.not_featured.not_popular_home.recent.limit(4).all
  end
  
end
