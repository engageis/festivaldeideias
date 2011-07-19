class UsersController < ApplicationController
  inherit_resources
  actions :show
  def show
    @user = User.find(params[:id])
    @editable = (current_user and current_user == @user)
    @ideas = @user.ideas.primary
    @versions = @user.ideas.secondary
    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
  end
end
