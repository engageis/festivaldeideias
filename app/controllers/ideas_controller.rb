# coding: utf-8

class IdeasController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => [:featured, :popular, :modified, :recent, :category]
  inherit_resources

  has_scope :featured, :type => :boolean, :only => :index
  has_scope :popular, :type => :boolean
  has_scope :latest, :type => :boolean
  has_scope :recent, :type => :boolean

  belongs_to :idea_category, :optional => true

  respond_to :html, :except => [:update]
  respond_to :json, :only => [:index, :update]

  before_filter :load_collaborators, :only => [ :show, :collaboration ]
  before_filter :load_resources

  def create
    # O usuário deve aceitar os todos os termos clicando no checkbox
    unless params[:terms_acceptance] && params[:cc_license] && params[:share_license] && params[:change_license]
      flash[:alert] = "Os termos de devem ser aceitos"
      return redirect_to request.referer
    end

    @idea = Idea.new(params[:idea])
    @idea.user = current_user if current_user
    # Agora depois de criada uma ideia, ela é exibida
    #create!(:notice => t('idea.message.success'),:alert => t('idea.message.failure')) { request.referer }
    create! do |success, failure|
      success.html {
        flash[:notice] = t('idea.message.success')
        return redirect_to category_idea_path(@idea.category_id, @idea)
      }
      failure.html {
        flash[:alert] = t('idea.message.failure')
        return redirect_to request.referer
      }
    end
  end

  def update
    update! do |format|
      format.json do
        render :json => @idea.to_json
      end
    end
  end

  def colaborate
    if @idea
      @collab = Idea.create_colaboration(params[:idea].merge(:user_id => current_user.id))
      flash[:alert] = t('idea.colaboration.success')
      redirect_to category_idea_path(@idea.category.id, @idea)
    end
  end

  def collaboration
    @idea = resource
    @collab = resource.colaborations.find(params[:collab])
  end

  def accept_collaboration
    @collab = resource.colaborations.find(params[:collab])
    resource.update_attributes title: @collab.title, headline: @collab.headline, description: @collab.description
    @collab.update_attribute :accepted, true
    flash[:notice] = t 'idea.colaboration.accepted', :user => @collab.user
    return redirect_to category_idea_path(resource.category, resource)
  end

  def refuse_collaboration
    @collab = resource.colaborations.find(params[:collab])
    @collab.update_attribute :accepted, false
    flash[:notice] = t('idea.colaboration.rejected')
    return redirect_to category_idea_path(resource.category, resource)
  end

  def index
    load_headers(:name => 'recent', :url => page_path('co-criacao'))
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

  protected
  def load_resources
    @ideas = end_of_association_chain.where(:parent_id => nil).includes(:user, :category) #querying only ideas, no collab.
    @categories ||= IdeaCategory.order('created_at ASC')
    @users ||= User.find(:all, :order => 'RANDOM()', :limit => 25, :include => :services)
    @ideas_count ||= Idea.where(:parent_id => nil).includes(:user, :category)
    @collab_count ||=  Idea.where("parent_id IS NOT NULL").includes(:user, :category, :parent)
    @ideas_latest ||= Idea.latest.includes(:user, :category)
    @ideas_featured ||= Idea.featured.includes(:user, :category)
    @ideas_popular ||= Idea.popular.includes(:user, :category).shuffle
  end

  def current_ability
    @current_ability ||= current_user ? UserAbility.new(current_user) : GuestAbility.new
  end

  def load_collaborators
    @collaborators = resource.colaborations.reduce({}){ |memo, c| memo[c.user_id] = c.user; memo }.values || []
  end

  # Holy baby jesus! <o>
  # Not anymore!!! :D
  def load_headers(options = {})
    name = options[:name] || action_name
    @ideas_title = I18n.translate("idea.filters.#{name}.title", options)

    #if name != 'category'
    unless options[:category_name]
      @ideas_about = I18n.translate("idea.filters.#{name}.about", options)
    end
  end
end
