#class PagesController < IdeasController
class PagesController < ApplicationController
  before_filter :load_resources

  def most_active_ideas
  end

  def ideas
  end

  def about
  end

  def themes
  end

  def regulation
  end

  def awards
  end

  protected
  def load_resources
    @categories ||= IdeaCategory.all
    @users ||= User.includes(:services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.latest
    @ideas_featured ||= Idea.featured
  end
end
