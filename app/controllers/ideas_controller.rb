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

  before_filter :load_collaborators, :only => [ :show, :edit, :collaboration ]
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

  def index
    load_headers(:name => 'recent', :url => page_path('co-criacao'))
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

  def colaborate
    if @idea
      @collab = Idea.create_colaboration(params[:idea].merge(:user_id => current_user.id))
      flash[:modal_alert] = t('idea.colaboration.success').html_safe
      redirect_to category_idea_path(@idea.category.id, @idea)
    end
  end

  def collaboration
    @idea = resource
    @collab = resource.colaborations.find(params[:collab])
  end

  def ramify
    @idea = Idea.find(params[:id])
    if Idea.ramify!(@idea)
      flash[:modal_alert] = t('idea.ramify.success').html_safe
      return redirect_to category_idea_path(@idea.category, @idea)
    end
  end

  def accept_collaboration
    @collab = resource.colaborations.find(params[:collab])
    resource.update_attributes(title: @collab.title,
                               headline: @collab.headline,
                               description: @collab.description,
                               minimum_investment: @collab.minimum_investment)
    @collab.update_attribute :accepted, true
    flash[:modal_alert] = t('idea.colaboration.accepted', :user => @collab.user.name).html_safe
    return redirect_to category_idea_path(resource.category, resource)
  end

  def refuse_collaboration
    @collab = resource.colaborations.find(params[:collab])
    @collab.update_attribute :accepted, false
    flash[:modal_alert] = t('idea.colaboration.rejected', :user => @collab.user.name).html_safe
    return redirect_to category_idea_path(resource.category, resource)
  end

  def modified
    @ideas = @ideas.latest
    load_headers
    render :index
  end

  def recent
    @ideas = @ideas.recent
    load_headers
    render :index
  end

  def popular
    @ideas = @ideas.popular.shuffle
    load_headers
    render :index
  end

  def featured
    #redirect_to :root
    @ideas = @ideas.featured
    load_headers(:url => page_path('co-criacao'))
    render :index
  end

  def category
    @category = IdeaCategory.find(params[:idea_category_id])
    @ideas = @category.ideas
    @ideas_about = @category.description
    load_headers(:category_name => @category.name)
    render :index
  end

  def search 
    if params[:keyword]
      @ideas = Idea.without_parent.match_and_find(params[:keyword])
      @query = params[:keyword]
    end
  end

  def cocreate
  end

  protected
  def load_resources
    #querying only ideas, no collab.
    @ideas = end_of_association_chain.without_parent.includes(:user, :colaborations, :category)

    @categories     ||= IdeaCategory.order('created_at')
    @users          ||= User.find(:all, :order => 'RANDOM()', :include => :services)
    @ideas_count    ||= Idea.without_parent.includes(:user, :category)
    @collab_count   ||= Idea.colaborations.includes(:user, :category, :parent)
    @ideas_latest   ||= Idea.latest.includes(:user, :category)
    @ideas_featured ||= Idea.featured.includes(:user, :category)
    @ideas_popular  ||= Idea.popular.includes(:user, :category).shuffle
  end

  def current_ability
    @current_ability ||= current_user ? UserAbility.new(current_user) : GuestAbility.new
  end

  def load_collaborators
    @collaborators = resource.accepted_colaborations.reduce({}){ |memo, c| memo[c.user_id] = c.user; memo }.values || []
  end


  def load_headers(options = {})
    name = options[:name] || action_name
    @ideas_title = I18n.translate("idea.filters.#{name}.title", options)

    unless options[:category_name]
      @ideas_about = I18n.translate("idea.filters.#{name}.about", options)
    end
  end
end
