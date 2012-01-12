class IdeasController < ApplicationController

  inherit_resources

  has_scope :featured, :type => :boolean, :default => false, :only => :index
  has_scope :latest
  has_scope :recent

  belongs_to :idea_category, :optional => true

  respond_to :html, :json
  before_filter :load_resources

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user if current_user
    create!(t('idea.message.success')) { return redirect_to :back }
  end

  protected
  def load_resources
    @ideas ||= end_of_association_chain.page params[:page]
    @categories ||= parent? ? parent.idea_categories : IdeaCategory.all
    @users ||= User.all(:include => :services)
    @ideas_count ||= @ideas.count
    @ideas_latest ||= Idea.latest
    @ideas_featured ||= Idea.featured
  end

end
