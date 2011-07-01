class IdeasController < ApplicationController

  inherit_resources
  
  def index
    @featured = current_site.ideas.featured.limit(4).all
    @popular = current_site.ideas.not_featured.popular_home.all
    @recent = current_site.ideas.not_featured.not_popular_home.recent.limit(4).all
  end
  
end
