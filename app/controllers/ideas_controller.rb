class IdeasController < ApplicationController
  load_and_authorize_resource
  inherit_resources

  actions :index, :show, :create, :update
  respond_to :html, :except => [:update]
  respond_to :json, :only => [:index, :update]
  
  def index
    index! do |format|
      format.html do
        @featured = current_site.ideas.featured.limit(4).all
        @popular = current_site.ideas.not_featured.popular.limit(4).all
        @recent = current_site.ideas.not_featured.recent.limit(4).all
        @count = current_site.ideas.count
      end
      format.json do
        @ideas = current_site.ideas.search(params[:search]).page params[:page]
        render :json => @ideas.to_json
      end
    end
  end
  
  def explore
    @title = t('ideas.explore.title')
    @categories = current_site.categories.with_ideas.order(:name).all
  end
  
  def show
    show! do
      @editable = (current_user and current_user == @idea.user)
      @versions = @idea.versions.order("created_at DESC").all
      @title = @idea.title
    end
  end
  
  def create
    return unless require_login
    @idea = Idea.new(params[:idea])
    @idea.site = current_site
    @idea.user = current_user
    @idea.template = current_site.template
    create!
  end
  
  def update
    update! do |format|
      format.json do
        render :json => @idea.to_json
      end
    end
  end
  
  def create_fork
    idea = Idea.find(params[:id])
    fork = idea.create_fork(current_user)
    if fork
      flash[:success] = t('ideas.create_fork.success')
      redirect_to idea_path(fork)
    else
      flash[:failure] = t('ideas.create_fork.failure')
      redirect_to idea_path(idea)
    end
  end
  
  def merge
    idea = Idea.find(params[:id])
    if idea.merge!(params[:from_id])
      flash[:success] = t('ideas.merge.success')
      redirect_to idea_path(idea)
    else
      flash[:failure] = t('ideas.merge.failure')
      redirect_to "#{idea_path(idea)}#versions"
    end
  end
    
end
