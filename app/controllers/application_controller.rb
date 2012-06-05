class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :is_signed_in?, :current_user_image
  before_filter :load_pages_for_the_links

  protected
  def current_user
    @current_user ||= User.find_by_id(cookies[:user], :include => :ideas)
  end

  def is_signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
    cookies[:user] = { :value => user.id, :expires => 30.days.from_now }
  end

  def load_pages_for_the_links
    @pages_for_links = Page.order('position, title ASC').select(['title', 'slug'])
  end
end
