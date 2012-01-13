class IdeasController < ApplicationController

  inherit_resources

  has_scope :featured, :type => :boolean, :only => :index
  has_scope :popular
  has_scope :latest
  has_scope :recent

  belongs_to :idea_category, :optional => true

  respond_to :html, :except => [:update]
  respond_to :json, :only => [:index, :update]

  before_filter :load_resources

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user if current_user
    create!(
            :notice => t('idea.message.success'),
            :alert => t('idea.message.failure')
    ) { request.referer }
  end

  protected
  def load_resources
    @categories ||= parent? ? parent.idea_categories : IdeaCategory.all
    @users ||= User.all(:include => :services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.latest
    @ideas_featured ||= Idea.featured
  end

end
