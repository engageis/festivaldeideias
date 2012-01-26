#class PagesController < IdeasController
class PagesController < ApplicationController
  inherit_resources
  actions :show
  before_filter :load_resources

  protected
  def load_resources
    @categories ||= IdeaCategory.all
    @users ||= User.includes(:services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.latest
    @ideas_featured ||= Idea.featured
  end
end
