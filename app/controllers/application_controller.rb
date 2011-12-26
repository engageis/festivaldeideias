class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :is_signed_in?

  protected
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def is_signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end


end
