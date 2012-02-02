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

  before_filter :load_resources

  def create
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
      @collab = Idea.create_colaboration(params[:idea])
      redirect_to category_idea_path(@idea)
    end
  end

  def index
    load_headers(:name => 'featured', :url => page_path('o-que-e-co-criacao'))
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
    @ideas = @ideas.popular
    load_headers
    render :index
  end

  def featured
    #redirect_to :root
    @ideas = @ideas.featured
    load_headers(:url => page_path('o-que-e-co-criacao'))
    render :index
  end

  def category
    category = IdeaCategory.find(params[:idea_category_id])
    @ideas = category.ideas
    load_headers(:category_name => category.name)
    render :index
  end

  protected
  def load_resources
    @ideas = end_of_association_chain.where(:parent_id => nil) #querying only ideas, no collab.
    @categories ||= IdeaCategory.all
    @users ||= User.all(:include => :services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.latest
    @ideas_featured ||= Idea.featured
  end

  def current_ability
    @current_ability ||= current_user ? UserAbility.new(current_user) : GuestAbility.new
  end

  # Holy baby jesus! <o>
  # Not anymore!!! :D
  def load_headers(options = {})
    name = options[:name] || action_name
    @ideas_title = I18n.translate("idea.filters.#{name}.title", options)
    # TODO: mudar a condicional quando houver descrição das categorias
    if name != 'category'
      @ideas_about = I18n.translate("idea.filters.#{name}.about", options)
    end
  end
end
