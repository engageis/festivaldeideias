#class PagesController < IdeasController
class PagesController < ApplicationController
  #before_filter :validate_user, :except => :show
  #authenticate_admin_user! :except => :show

  inherit_resources
  actions :show

  before_filter :load_resources

  def sort
    ids = params[:page].map(&:to_i)
    ids.each_with_index do |id, index|
      Page.update_all({ :position => 1 + index }, { :id => id })
    end
    render :nothing => true
  rescue
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
