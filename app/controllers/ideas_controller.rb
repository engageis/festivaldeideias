class IdeasController < ApplicationController

  load_and_authorize_resource
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

  protected
  def load_resources
    @ideas = end_of_association_chain.where(:parent_id => nil) #querying only ideas, no collab.
    @categories ||= IdeaCategory.all
    @users ||= User.all(:include => :services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.latest
    @ideas_featured ||= Idea.featured
    load_title_and_about
  end

  def current_ability
    @current_ability ||= current_user ? UserAbility.new(current_user) : GuestAbility.new
  end

  # Holy baby jesus! <o>
  def load_title_and_about
    if params[:lastest]
      @ideas_title = I18n.translate('idea.filters.latest.title')
      @ideas_about = I18n.translate('idea.filters.latest.about')
    elsif params[:recent]
      @ideas_title = I18n.translate('idea.filters.recent.title')
      @ideas_about = I18n.translate('idea.filters.recent.about')
    elsif params[:popular]
      @ideas_title = I18n.translate('idea.filters.popular.title')
      @ideas_about = I18n.translate('idea.filters.popular.about')
    elsif params[:featured]
      @ideas_title = I18n.translate('idea.filters.featured.title')
      @ideas_about = I18n.translate('idea.filters.featured.about', :url => page_path("o-que-e-co-criacao"))
    elsif params[:idea_category_id]
      category = IdeaCategory.find(params[:idea_category_id])
      @ideas_title = I18n.translate('idea.filters.category.title', :category_name => category.name)
      @ideas_about = nil # substituir pela descrição da categoria
    end
  end
end
