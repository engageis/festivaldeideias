class IdeasController < ApplicationController
  load_and_authorize_resource
  inherit_resources
  caches_action :index, :layout => false, :unless => Proc.new { |c| c.request.format.json? }

  actions :index, :show, :create, :update, :destroy
  respond_to :html, :except => [:update]
  respond_to :json, :only => [:index, :update]
  # cache_sweeper :idea_sweeper
  
  def index
    index! do |format|
      format.html do
        @featured = current_site.ideas.featured.primary.limit(4).all
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
      @versions_changed = false
      if @editable
        @idea.versions.each do |version|
          if version.parent_need_to_merge?
            @versions_changed = true
            break
          end
        end
      end
    end
  end
  
  def create
    @idea = Idea.new(params[:idea])
    @idea.site = current_site
    @idea.user = current_user
    @idea.template = current_site.template
    if @idea.save
      redirect_to @idea
      flash[:notice] = "Sua ideia foi criada com sucesso"
    else
      redirect_to root_path
      flash[:error] = "Houve um erro ao criar a sua ideia"
    end
  end
  
  def update
    update! do |format|
      format.json do
        render :json => @idea.to_json
      end
    end
  end
  
  def destroy
    idea = Idea.find(params[:id])
    if idea.destroy
      flash[:success] = t('ideas.remove.success')
      redirect_to root_path
    else
      flash[:failure] = t('ideas.remove.failure')
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
      redirect_to review_conflicts_idea_path(idea, params[:from_id])
    end
  end
  
  def review_conflicts
    @idea = Idea.find(params[:id])
    @from = Idea.find(params[:from_id])
    @conflicts = @idea.conflicts(params[:from_id])["attributes"]
  end
  
  def resolve_conflicts
    idea = Idea.find(params[:id])
    conflict_attributes = JSON.parse(params[:conflict_attributes]) unless params[:conflict_attributes].empty?
    conflict_attributes = {} unless conflict_attributes
    if idea.resolve_conflicts!(params[:from_id], conflict_attributes)
      flash[:success] = t('ideas.resolve_conflicts.success')
      redirect_to idea_path(idea)
    else
      flash[:failure] = t('ideas.resolve_conflicts.failure')
      redirect_to review_conflicts_idea_path(idea, params[:from_id])
    end
  end
 
end
