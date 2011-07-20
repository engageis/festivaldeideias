class UsersController < ApplicationController
  load_and_authorize_resource
  inherit_resources
  actions :show
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
end
