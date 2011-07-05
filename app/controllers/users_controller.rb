class UsersController < ApplicationController
  inherit_resources
  actions :show
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
  end
end
