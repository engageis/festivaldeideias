class IdeasController < ApplicationController

  inherit_resources

  has_scope :featured, :type => :boolean, :default => false, :only => :index
  has_scope :latest
  has_scope :recent

  belongs_to :idea_category, :optional => true

  respond_to :html, :json
  before_filter :load_resources

  def navigate
  end

  protected
  def load_resources
    @categories = parent? ? parent.idea_categories : IdeaCategory.all
    @users ||= User.all(:include => :services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.order(:updated_at).all
    @ideas_featured ||= Idea.order(:likes).all
  end
end
