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

  protected
  def load_resources
    @categories ||= IdeaCategory.all
    @users ||= User.all(:include => :services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.latest
    @ideas_featured ||= Idea.featured
  end

  def current_ability
    @current_ability ||= case
                         when current_user
                           UserAbility.new(current_user)
                         else
                           GuestAbility.new
                         end
  end
end
