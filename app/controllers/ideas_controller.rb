# coding: utf-8

class IdeasController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => [:featured, :popular, :modified, :recent, :category]

  inherit_resources

  has_scope :featured,  :type => :boolean, :only => :index
  has_scope :popular,   :type => :boolean
  has_scope :latest,    :type => :boolean
  has_scope :recent,    :type => :boolean

  belongs_to :idea_category, :optional => true

  actions :all, except: [:destroy]

  before_filter only: [:create] { @idea.user = current_user if current_user }

  before_filter :load_resources

  before_filter only: [:create] do
    unless params[:terms_acceptance] && params[:cc_license] && params[:share_license] && params[:change_license]
      render new_idea_path and return
    end
  end

  before_filter only: [:show]   { @idea.update_facebook_likes }
  before_filter only: [:cocreate] do
    if current_user 
      @token = 
        TOKBOX.generate_token session_id: @idea.tokbox_session, 
        role: OpenTok::RoleConstants::PUBLISHER, 
        connection_data: "username=#{current_user.name}"
    end
  end

  def pin_show
    render layout: false
  end

  def index
    load_headers(:name => 'recent', :url => page_path('co-criacao'))
    @audits = Audit.recent.limit(10)
    @maximum_ideas = 10
    @recent_liked_ideas = []
    @recent_commented_ideas = []
    feed = Blog.fetch_last_posts
    @entries = feed.entries.first(3)
    @ideas = Idea.recent.limit(9)
    respond_to do |format|
      format.html
      format.json { render json: @ideas}
    end
  end

  def update
    update! do |format|
      format.html do
        return redirect_to category_idea_path(@idea.category, @idea)
      end
      format.json do
        render :json => @idea.to_json
      end
    end
  end

  def modified
    @ideas = @ideas.latest
    load_headers
    render :explore
  end

  def recent
    @ideas = @ideas.recent
    load_headers
    render :explore
  end

  def popular
    @ideas = @ideas.popular
    load_headers
    render :explore
  end

  def featured
    #redirect_to :root
    @ideas = @ideas.featured
    load_headers(:url => page_path('co-criacao'))
    render :explore
  end

  def category
    @category = IdeaCategory.find(params[:idea_category_id])
    @ideas = @category.ideas
    @ideas_about = @category.description
    load_headers(:category_name => @category.name)
    render :explore
  end

  def search 
    if params[:keyword]
      @ideas = Idea.match_and_find(params[:keyword])
      @query = params[:keyword]
    end
  end

  def cocreate
  end

  def map
  end

  protected
  def load_resources
    #querying only ideas, no collab.
    @ideas = end_of_association_chain.includes(:user, :category, :collaborators)

    @categories ||= IdeaCategory.order('created_at')
    @users ||= User.find(:all, :order => 'RANDOM()', :include => :services)
    @ideas_count ||= Idea.includes(:user, :category)
    @collaborators_count ||= Collaborator.count
    @ideas_latest ||= Idea.latest.includes(:user, :category)
    @ideas_featured ||= Idea.featured.includes(:user, :category)
    @ideas_popular ||= Idea.popular.includes(:user, :category).shuffle
  end

  def current_ability
    @current_ability ||= current_user ? UserAbility.new(current_user) : GuestAbility.new
  end

  def load_headers(options = {})
    name = options[:name] || action_name
    @ideas_title = I18n.translate("idea.filters.#{name}.title", options)

    unless options[:category_name]
      @ideas_about = I18n.translate("idea.filters.#{name}.about", options)
    end
  end
end
