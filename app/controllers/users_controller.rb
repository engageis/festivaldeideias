class UsersController < ApplicationController
  load_and_authorize_resource
  inherit_resources
  actions :show, :update
  respond_to :html
  respond_to :json, :only => [:update]
  def show
    @user = User.find(params[:id])
    @editable = (current_user and current_user == @user)
    @ideas = @user.ideas.primary
    @versions = @user.ideas.secondary
    @title = @user.name
    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
  end

  def my_profile
    return unless require_login
    redirect_to user_path(current_user)
  end

  def update
    update! do |format|
      format.json do
        render :json => @user.to_json
      end
      format.html
    end
  end
  
end
